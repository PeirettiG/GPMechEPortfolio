---
permalink: /moda-printer/
title: Melt-On-Demand (MODA) Printer Prototype
header:
  overlay_image: /assets/images/projects/moda/setup-overview.jpg
  overlay_filter: 0.5
  caption: MODA prototype test setup
toc: true
toc_label: Contents
excerpt: "Retrofitted an industrial inkjet printhead to demonstrate a melt-on-demand ink delivery scheme. Designed a custom Arduino shield, implemented closed-loop temperature control over RS485, and characterized system performance across a sweep of operating conditions."
---

**Year:** 2025 — Markem-Imaje  
**Skills:** Arduino · RS485/MODBUS · PCB/Shield Design · Thermal Systems · Embedded Systems · Test & Measurement

---

## Overview

Hot-melt inkjet printers keep their entire ink supply at jetting temperature (> 100°C) at all times — even when not printing. **Melt-on-Demand (MODA)** is an architecture where the supply reservoir is held at a lower holding temperature (~80 °C) and only heats up to jetting temperature when ink is needed. Benefits include lower energy consumption, reduced risk of hot ink splashing, and a cooler print head enclosure.

This project retrofitted an existing model printhead to prove out MODA experimentally and determine minimum melt times required across a range of printing intensities.

{% include figure image_path="/assets/images/projects/moda/setup-overview.jpg" alt="MODA test setup overview" caption="Test setup: 5800 print head, Arduino Mega with custom shield, Omega temperature controller, Keysight DAQ, DataQ DAQ, and power supply." %}

{% include figure image_path="/assets/images/projects/moda/setup-laptop.jpg" alt="Test setup with laptop" caption="Lab computer connected to all instruments for data logging and control." %}

---

## Modifications to Enable On-Demand Melt Cycles

The standard printer firmware maintains multiple ink reservoirs  and jetting arrays at jetting temperature continuously. And the onboard sensors will stop all function if they measure a value outside the acceptable range. To enable MODA, the printer's reservoir temperature control had to be completely bypassed using external hardware and a custom Arduino-based controller while satisfying the printer's onboard sensors.

### Supply Reservoir Thermistor Bypass

The 5800's PCA monitors a thermistor in the main reservoir to regulate its temperature. To take over temperature control externally, the thermistor was replaced with a fixed value resistor that matches the thermistor value at jetting temperature. This disables the printer's native heater control for that zone.

### External Heater & Temperature Controller

A replacement cartridge heater was inserted and driven by an Omega CN7833 temperature controller to regulate the supply reservoir temperature. Power is drawn from wall power through an isolation transformer and a variable autotransformer scaled to deliver 100 W at a lower voltage.

{% include figure image_path="/assets/images/projects/moda/supply-reservoir-schematic.png" alt="Supply reservoir temperature controller schematic" caption="Supply reservoir heater circuit: 120 VAC wall power → isolation transformer → variable autotransformer → Omega CN7833 controller → 124 Ω cartridge heater." %}

### Modified Supply Reservoir with Fins

The main reservoir was replaced with a custom version machined with internal fins to increase surface area and improve heat transfer from the heater to the ink. An additional port allowed a thermocouple to be inserted directly into the ink to measure its temperature directly.

{% include figure image_path="/assets/images/projects/moda/supply-reservoir-fins.jpg" alt="Modified supply reservoir with fins" caption="Modified supply reservoir: machined fins increase heat transfer, and an embedded thermocouple measures ink temperature directly." %}

### LOIS Signal Interception & Simulation

The LOIS (Low-On-Ink Sensor) is the thermistor the printer uses to detect when the primary reservoir is low on ink. In normal operation, when the LOIS voltage drops below threshold voltage, the printer initiates an ink transfer from the supply reservoir. In MODA, this transfer must be delayed until the supply reservoir has had time to melt.

The challenge: to delay the ink transfer, the Arduino needed to simultaneously:
1. Monitor the real LOIS voltage (to know when ink is genuinely low)
2. Send a fake LOIS signal to the printer to prevent it from starting the transfer prematurely

The original LOIS circuit in the printer is part of a voltage divider with a static resistor and the LOIS thermistor. The same divider was replicated on the Arduino shield to power and read the sensor without changing its dynamics. An additional voltage divider scaled the LOIS voltage down to fit within the Arduino's 5V analog input limit.

To simulate the LOIS signal sent back to the printer, a digital potentiometer was initially considered, but no available part could handle steady state current of the circuit at temperature. Instead, an **N-channel MOSFET (2N7000BU)** was used to switch a set of resistors in parallel across the LOIS connector:

| MOSFET Gate  | Equivalent Resistance | Simulated Voltage | Printer Sees           |
| ------------ | --------------------- | ----------------- | ---------------------- |
| De-energized | 110 Ω                 | 4.07 V            | In ink — no transfer   |
| Energized    | 94 Ω (parallel)       | 3.70 V            | Out of ink — transfer! |

The Arduino controls the gate via digital pin 3. The LOIS voltage is read on analog pin A1.

---

## System Interactions: Arduino, Printer & Temperature Controller

The Arduino Mega acts as the central controller, coordinating three independent subsystems:

```
        ┌─────────────────────┐
        │   Lab PC (logging)  │
        └──────────┬──────────┘
                   │ USB
        ┌──────────▼──────────┐          ┌─────────────────┐
        │   Arduino Mega +    │◄──RS485─►│  Omega CN7800   │
        │   Custom Shield     │  MODBUS  │ Temp Controller │
        └──┬───────────────┬──┘  ASCII   └────────┬────────┘
           │               │                      │ relay
   reads   │               │ writes               │  closes
   real    │               │ simulated            │
   LOIS    │               │ LOIS                 ▼
           │               │              ┌──────────────┐
        ┌──▼───────────────▼──┐           │ Supply Res.  │
        │   Printhead (PH)    │◄──────────┤ 124Ω Heater  │
        └─────────────────────┘           └──────────────┘
```


{% include figure image_path="/assets/images/projects/moda/moda-sequence-sketch.png" alt="MODA ink transfer sequence" caption="MODA control sequence: when the real LOIS goes low, the melt timer starts and the simulated LOIS holds the printer back. After the timer expires, the simulated LOIS drops and the printer initiates the ink transfer." %}

### Arduino ↔ Omega Temperature Controller (RS485 / MODBUS ASCII)

The Omega CN7833 supports remote setpoint changes via **RS485** using the **MODBUS ASCII** protocol over a single shielded twisted-pair cable. This is what allows the Arduino to dynamically raise the supply reservoir setpoint from the lower temperature setpoint to Jetting temperature when the LOIS goes low, and lower it back to holding temperature after the transfer completes.

I used a TTL-to-RS485 converter to interface between the Arduino's UART and the RS485 cable. MODBUS ASCII messages are constructed and sent as text frames — for example, writing to address `0x1001` (the setpoint register) with the value `0x04E2` (1250 in decimal, representing 125.0 °C):

```
:06100104E2[LRC]
```

The **Longitudinal Redundancy Check (LRC)** is appended to every message as an error check, calculated by summing each data byte and taking the two's complement. The Arduino script includes a `calculateLRC()` function that handles this automatically.

### Arduino ↔ 5800 Printer (LOIS Control)

As described above, the Arduino reads the real LOIS voltage on A1 and drives the MOSFET gate on pin 3 to control the simulated LOIS sent to the printer. The full control sequence is:

1. **Holding:** Maintain the reservoir at the holding temperature and simulate the LOIS as satisfied.
2. **Ink level drops:** A melt timer is started and the arduino sends a command to increase the temperature setpoint to jetting temperature. The simulated LOIS is held high to prevent an ink transfer for now.
3. **Melt timer expires:** Simulated LOIS drops low which causes the printer to see an out-of-ink state and it initiates the ink transfer normally.
4. **LOIS satisfied (greater than threshold):** Printer stops the transfer, and the setpoint commanded back to lower holding temperature.

{% include figure image_path="/assets/images/projects/moda/ink-transfer-chart.png" alt="Ink transfer dynamics" caption="A normal ink transfer: supply reservoir pressurizes above 2 PSI to open the check valve, ink flows until the LOIS is satisfied, then pressure vents. Typical transfer takes 20–30 seconds." %}

---

## Custom Arduino Shield

All the interfacing circuitry was built onto a custom protoboard shield that stacks directly on the Arduino Mega. The shield consolidates three functional areas:

{% include figure image_path="/assets/images/projects/moda/arduino-shield-photo.jpg" alt="Custom Arduino shield photo" caption="Custom Arduino Mega shield with RS485 module (top), LOIS reading circuit (left), and LOIS simulation circuit (right)." %}

{% include figure image_path="/assets/images/projects/moda/arduino-shield-schematic.png" alt="Arduino shield schematic" caption="Arduino shield schematic: RS485 TTL converter (top), LOIS voltage divider and A1 measurement (left), MOSFET-based LOIS simulator (right)." %}

- **1: RS485 Interface (top of shield)**
	- The TTL-to-RS485 module is mounted at the top of the shield and wired to the Arduino's hardware Serial port. Pull-up, pull-down, and 120 Ω termination resistors are included to minimize noise on the twisted pair.
- **2: Real LOIS Measurement (left side)**
	- A DC power supply feeds a LOIS voltage divider, replicating the original printer circuit. A second divider scales the voltage into the Arduino's 0–5 V analog range. Pin A1 reads this value continuously.
- **3: Simulated LOIS Output (right side)**
	- A 2N7000BU N-channel MOSFET is driven by digital pin 3. When the gate is low, the equivalent circuit resembles the state of the LOIS when in ink. When the gate goes high, additional resistors are connected in parallel, dropping the equivalent resistance, and pulling the simulated voltage below the printer's low ink threshold.

---

## Test Results

The MODA prototype was tested at three ink consumption rates with progressively shorter melt timers to determine performance envelopes. Each condition ran for 1.5–2.5 hours to confirm sustained stability across multiple ink transfers.

## Skills Demonstrated

- **Embedded firmware (Arduino C++):** State-machine control logic, RS485/MODBUS ASCII master implementation including LRC checksum, analog sensor sampling.
- **Electronics design:** Custom protoboard shield, voltage divider and impedance scaling, MOSFET-switched resistor network, current-rating analysis.
- **Instrumentation & test:** Multi-channel thermocouple measurement, parallel DAQ logging, dynamic-setpoint temperature control, isolation/variac power conditioning.
- **Systems integration:** Inserting a microcontroller in the middle of an existing closed-loop sensor signal without modifying the host system.
- **Test design and analysis:** Sweeping throughput × melt-timer parameter space, defining failure-mode acceptance criteria, characterizing time-between-events and transfer-duration trends.