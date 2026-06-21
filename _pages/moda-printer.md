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
**Skills:** Design of experiment · Measurement and Data Acquisition · Arduino programming · MODBUS & RS485 communications · Electronics & shield design · Thermal Systems · Embedded Systems

---

## Overview

Current Hot-melt Ink Jet printers maintain their entire ink supply at jetting temperature (>100°C) at all times even when not printing. This consumes a lot of power to maintain the system at elevated temperatures, and can cause contact thermal hazards on the exterior of the print head. 

The purpose of this project was to explore a **Melt-on-Demand (MODA)** architecture where a supply ink reservoir is held at a lower temperature (~80°C) and then only heats up to jetting temperature when ink is needed. Benefits of this design include lower steady-state energy consumption, reduced risk of hot liquid ink splashing, and a cooler print head enclosure. 

This project retrofitted an existing model printhead to prove out Melt-on-Demand experimentally and determine the minimum melt times required across a range of printing intensities.


{% include figure image_path="/assets/images/projects/moda/setup-overview.jpg" alt="MODA test setup overview" caption="Test setup: 5800 print head, Arduino Mega with custom shield, Omega temperature controller, Keysight DAQ, DataQ DAQ, and power supply." %}

{% include figure image_path="/assets/images/projects/moda/setup-laptop.jpg" alt="Test setup with laptop" caption="Lab computer connected to all instruments for data logging and control." %}

---

## Modifications to Enable On-Demand Melt Cycles

The standard printer firmware maintains multiple ink reservoirs and jetting arrays at jetting temperature continuously, and the standard temperature sensors will stop all function if they measure a value outside the acceptable range. This is built by design and is ideal to detect faults and prevent damaging hardware during normal operation. However, without the ability compile new software for this legacy product, this became an obstacle to overcome for my purposes of experimentation. To enable MODA, the printer's supply reservoir temperature control had to be completely side-stepped using an external temperature controller and heat source, and a custom Arduino controller was made to satisfy the printer's onboard sensors.

### Supply Reservoir Thermistor Bypass

The PCB of the legacy printer I was modifying uses a thermistor placed in the main supply reservoir to regulate its temperature. To take over temperature control without causing a fault, I replaced the thermistor with a fixed value resistor that matches the thermistor at the desired temperature of the printer. This satisfies the native heater control for that zone and allows me to control the temperature via external means 

### External Heater & Temperature Controller

A replacement cartridge heater was inserted into the reservoir and driven by an Omega CN7833 temperature controller to regulate the supply reservoir temperature. Temperature is measured by a T-type thermocouple connected directly to the Omega temperature controller. Supply power is drawn from 120VAC mains power through an isolation transformer for safety and a variable autotransformer scales the voltage down to deliver 100 W through the cartridge heater. A schematic of the external temperature control is shown below from a previous experiment where the same system controlled 2 heaters.

{% include figure image_path="/assets/images/projects/moda/supply-reservoir-schematic.png" alt="Supply reservoir temperature controller schematic" caption="Supply reservoir heater circuit: 120 VAC wall power → isolation transformer → variable autotransformer → Omega CN7833 controller → 124 Ω cartridge heater." %}

### Modified Supply Reservoir with Fins

The physical reservoir was replaced with a custom version machined with internal fins to increase surface area and improve heat transfer from the heater to the ink. This would be useful because at the lower temperature, the printer ink is in a somewhat solid mushy phase, and the fins would help increase the ink melt rate during a melt cycle. Additionally, a threaded hole and fastener are placed to hold a thermocouple directly in the ink and measure its temperature.

{% include figure image_path="/assets/images/projects/moda/supply-reservoir-fins.jpg" alt="Modified supply reservoir with fins" caption="Modified supply reservoir: machined fins increase heat transfer, and an embedded thermocouple measures ink temperature directly." %}

### LOIS Signal Interception & Simulation

This aspect was the most complex electrical component of this project. The printer uses a LOIS (Low-On-Ink-Sensor) to measure the level of ink in the primary reservoir. The LOIS is a NTC high-temperature thermistor that heats up when out of ink, but cools down when in ink. The LOIS is part of a voltage divider who's out put voltage changes based on the temperature of the sensor, and therefore the ink level. 

When the sensor voltage drops below a threshold, the printer initiates an ink transfer process refill the primary reservoir from the supply. However, if the ink temperature is too low for it to flow, the transfer must be delayed until the supply reservoir ink has had time to melt.  

A challenge for this project was to to delay the ink transfer. Therefore, the Arduino needed to simultaneously:
1. Monitor the real LOIS voltage (to know when ink is genuinely low)
2. Send a fake LOIS signal to the printer to prevent it from starting the transfer prematurely

The original LOIS circuit in the printer is part of a voltage divider with a static resistor and the LOIS thermistor. I replicated the same divider on the Arduino shield to with connectors for a 12V power supply and the physical LOIS harness. Additionally, I added a second voltage divider to scale the signal down to the Arduino's 0-5V analog input limit. 

To simulate the LOIS signal sent back to the printer, I needed to find a way to change the equivalent resistance across the terminals of the PCB's connector in a manner that emulates the LOIS. I originally considered a digital potentiometer, but there was no available part that could handle the current and power requirements of the circuit. Instead, I used an N-channel MOSFET to connect/disconnect a set of resistors in parallel to control the equivalent resistance of the circuit. 

| MOSFET Gate  | Equivalent Resistance | Simulated Voltage | Printer Sees           |
| ------------ | --------------------- | ----------------- | ---------------------- |
| De-energized | 110 Ω                 | 4.07 V            | In ink — no transfer   |
| Energized    | 94 Ω (parallel)       | 3.70 V            | Out of ink — transfer! |

The Arduino controls the gate via digital pin 3. The LOIS voltage is read on analog pin A1.

{% include figure image_path="/assets/images/projects/moda/arduino-shield-schematic.png" alt="Arduino shield schematic" caption="Arduino shield schematic: RS485 TTL converter (top), LOIS voltage divider and A1 measurement (left), MOSFET-based LOIS simulator (right)." %}

---
## Custom Arduino Shield

All the interfacing circuitry was built onto a custom protoboard shield that stacks directly on the Arduino Mega. The shield consolidates three functional areas:

{% include figure image_path="/assets/images/projects/moda/arduino-shield-photo.jpg" alt="Custom Arduino shield photo" caption="Custom Arduino Mega shield with RS485 module (top), LOIS reading circuit (left), and LOIS simulation circuit (right)." %}


- **1: RS485 Interface (top of shield)**
	- The TTL-to-RS485 module is mounted at the top of the shield and wired to the Arduino's hardware Serial port. Pull-up, pull-down, and 120 Ω termination resistors are included to minimize noise on the twisted pair.
- **2: Real LOIS Measurement (left side)**
	- A DC power supply feeds a LOIS voltage divider, replicating the original printer circuit. A second divider scales the voltage into the Arduino's 0–5 V analog range. Pin A1 reads this value continuously.
- **3: Simulated LOIS Output (right side)**
	- A 2N7000BU N-channel MOSFET is driven by digital pin 3. When the gate is low, the equivalent circuit resembles the state of the LOIS when in ink. When the gate goes high, additional resistors are connected in parallel, dropping the equivalent resistance, and pulling the simulated voltage below the printer's low ink threshold.

---

## System Interactions: Arduino, Printer & Temperature Controller

The Arduino Mega acts as the central controller, coordinating three independent subsystems:
- The Omega Temperature controller that reads the supply reservoir temperature and controls heating based on the setpoint. The setpoint is changed on-demand based on remote commands from the Arduino
- It measures the physical process value of the LOIS and ink level and executes logic based on its measurements.
- Simulated sensors to the print head to execute the ink transfer once the melt timer has expired. 

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


### Arduino ↔ Omega Temperature Controller (RS485 / MODBUS ASCII)

The Omega CN7833 supports remote setpoint changes via **RS485** using the **MODBUS ASCII** protocol over a single shielded twisted-pair cable. This is what allows the Arduino to dynamically raise the supply reservoir setpoint from the lower temperature setpoint to the jetting temperature when the LOIS goes low, and lower it back to holding temperature after the transfer completes.

I used a TTL-to-RS485 converter to interface between the Arduino's UART and the RS485 cable. MODBUS ASCII messages are constructed and sent as text frames — for example, writing to address `0x1001` (the setpoint register) with the value `0x04E2` (1250 in decimal, representing 125.0 °C):

```
:06100104E2[LRC]
```

The **Longitudinal Redundancy Check (LRC)** is appended to every message as an error check, calculated by summing each data byte and taking the two's complement. The Arduino script includes a `calculateLRC()` function that handles this automatically.

### Arduino ↔ 5800 Printer (LOIS Control)

As described above, the Arduino reads the real LOIS voltage on A1 and drives the MOSFET gate on pin 3 to control the simulated LOIS sent to the printer. The Arduino program implements a state-machine where different actions are taken based on the state of the print head. The full control sequence is:

1. **Holding:** Primary reservoir is good on ink. Maintain the supply reservoir at the holding temperature and simulate the LOIS as satisfied. 
2. **Melt Timer:** The LOIS voltage drops signaling that the primary reservoir is low on ink. A melt timer is started and the Arduino sends a command to increase the temperature setpoint to jetting temperature. The simulated LOIS is held high to prevent an ink transfer for now.
3. **Melt timer expires:** Simulated LOIS drops low which causes the printer to see an out-of-ink state and it initiates the ink transfer normally.
4. **LOIS satisfied (greater than threshold):** Printer stops the transfer, and the setpoint commanded back to lower holding temperature.

{% include figure image_path="/assets/images/projects/moda/moda-sequence-sketch.png" alt="MODA ink transfer sequence" caption="MODA control sequence: when the real LOIS goes low, the melt timer starts and the simulated LOIS holds the printer back. After the timer expires, the simulated LOIS drops and the printer initiates the ink transfer." %}

{% include figure image_path="/assets/images/projects/moda/ink-transfer-chart.png" alt="Ink transfer dynamics" caption="A normal ink transfer: supply reservoir pressurizes above 2 PSI to open the check valve, ink flows until the LOIS is satisfied, then pressure vents. Typical transfer takes 20–30 seconds." %}

---

## Data Acquisition & Testing

Experimental data was recorded with two physical DAQ units. One, a DataQ Daq was connected via USB to a laptop and was used to record any analog voltages such as the LOIS voltage signal or digital command signals such as when the simulated LOIS was sent high or low. In addition to the DataQ Daq, a Keysight / Agilent 34870A Data acquisition unit was used to record temperatures of the different regions as measured by the thermocouples. Data was recorded locally to the laptop, exported as CSVs, and later merged and synced to be graphed together. 

### Testing protocol

The jetting temperature and hold temperature were predetermined based on requirements from the ink chemistry and held constant for all experiments. The objective was to test the performance of the printer measuring it's ability to supply ink at different rates reliably without causing faults. 

The MODA prototype was tested at three ink consumption rates by printing a fixed image with known average ink consumption and then changing the package printing frequency. The mass of ink consumed over time was also measured to confirm the ink consumption rate. Each printing case was tested with progressively shorter melt timers to determine a performance envelope. A successful test was confirmed if the printer could run 1.5–2.5 hours without causing an ink transfer fault, confirming sustained stability across multiple ink transfers.

---
## Skills Demonstrated

- **Embedded firmware (Arduino C++):** State-machine control logic, RS485/MODBUS ASCII master implementation including LRC checksum, analog sensor sampling.
- **Electronics design:** Custom protoboard shield, voltage divider and impedance scaling, MOSFET-switched resistor network, current-rating analysis.
- **Instrumentation & test:** Multi-channel thermocouple measurement, parallel DAQ logging, dynamic-setpoint temperature control, isolation/variac power conditioning.
- **Systems integration:** Inserting a microcontroller in the middle of an existing closed-loop sensor signal without modifying the host system.
- **Test design and analysis:** Sweeping throughput × melt-timer parameter space, defining failure-mode acceptance criteria, characterizing time-between-events and transfer-duration trends.