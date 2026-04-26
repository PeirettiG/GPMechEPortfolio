---
permalink: /moda-printer/
title: "Melt-On-Demand (MODA) Printer Prototype"
header:
  image: /assets/images/projects/moda/setup-overview.jpg
  caption: "MODA prototype test setup"
toc: true
toc_label: "Contents"
---

**Year:** 2025 — Markem-Imaje  
**Skills:** Arduino · RS485/MODBUS · PCB/Shield Design · Thermal Systems · Embedded Systems · Test & Measurement

---

## Overview

Hot-melt inkjet printers keep their entire ink supply at jetting temperature (> 100°C) at all times — even when not printing. **Melt-on-Demand (MODA)** is an architecture where the supply reservoir is held at a lower holding temperature (~80 °C) and only heats up to jetting temperature when ink is needed. Benefits include lower energy consumption, reduced risk of hot ink splashing, and a cooler print head enclosure.

This project retrofitted an existing model printhead to prove out MODA experimentally and determine minimum melt times required across a range of printing intensities.

{% include figure image_path="/assets/images/projects/moda/setup-overview.jpg" alt="MODA test setup overview" caption="Test setup: 5800 print head, Arduino Mega with custom shield, Omega temperature controller, Keysight DAQ, DataQ DAQ, and power supply." %}
![[setup-overview.jpg]]

{% include figure image_path="/assets/images/projects/moda/setup-laptop.jpg" alt="Test setup with laptop" caption="Lab computer connected to all instruments for data logging and control." %}

---

## Modifications to Enable MODA

The standard printer firmware maintains the supply reservoir, primary reservoir, and jetting array all at jetting temperature continuously. And the onboard sensors will stop all function if they measure a value outside the acceptable range. To enable MODA, the printer's supply reservoir control had to be completely bypassed using external hardware and a custom Arduino-based controller while satisfying the printer's onboard sensors.

### Supply Reservoir Thermistor Bypass

The 5800's PCA monitors a thermistor in the supply reservoir to regulate its temperature. To take over temperature control externally, the thermistor was replaced with a fixed value resistor that matches the thermistor value at jetting temperature. This disables the printer's native heater control for that zone.

### External Heater & Temperature Controller

A **Omega CN7833 temperature controller** drives a **124 Ω cartridge heater** to regulate the supply reservoir temperature. Power is drawn from wall power through an isolation transformer and a variable autotransformer scaled to deliver 100 W at 111.3 VAC.

{% include figure image_path="/assets/images/projects/moda/supply-reservoir-schematic.png" alt="Supply reservoir temperature controller schematic" caption="Supply reservoir heater circuit: 120 VAC wall power → isolation transformer → variable autotransformer → Omega CN7833 controller → 124 Ω cartridge heater." %}

### Modified Supply Reservoir with Fins

The supply reservoir was replaced with a custom version machined with **internal fins** to increase surface area and improve heat transfer from the heater to the ink. An additional port allowed a thermocouple to be inserted directly into the ink to measure its temperature independently of the heater.

{% include figure image_path="/assets/images/projects/moda/supply-reservoir-fins.jpg" alt="Modified supply reservoir with fins" caption="Modified supply reservoir: machined fins increase heat transfer, and an embedded thermocouple measures ink temperature directly." %}

### LOIS Signal Interception & Simulation

The LOIS (Low-On-Ink Sensor) is the thermistor the printer uses to detect when the primary reservoir is low on ink. In normal operation, when the LOIS voltage drops below **3.85 V**, the printer initiates an ink transfer from the supply reservoir. In MODA, this transfer must be delayed until the supply reservoir has had time to melt.

The challenge: to delay the ink transfer, the Arduino needed to simultaneously:
1. **Monitor** the real LOIS voltage (to know when ink is genuinely low)
2. **Send a fake LOIS signal** to the printer to prevent it from starting the transfer prematurely

The original LOIS circuit in the 5800 is a 12 V voltage divider with a 220 Ω resistor. The same divider was replicated on the Arduino shield to power and read the sensor without changing its dynamics. An additional voltage divider scaled the LOIS voltage down from the 3.5–12 V range to fit within the Arduino's 5 V analog input limit.

{% include figure image_path="/assets/images/projects/moda/lois-circuit.png" alt="LOIS conditioning circuit" caption="Original LOIS conditioning circuit inside the 5800 PCA, used as reference for the shield design." %}

To simulate the LOIS signal sent back to the printer, a **digital potentiometer** was initially considered, but no available part could handle the 20–30 mA of current in the circuit. Instead, an **N-channel MOSFET (2N7000BU)** was used to switch a set of resistors in parallel across the LOIS connector:

| MOSFET Gate | Equivalent Resistance | Simulated Voltage | Printer Sees |
|-------------|-----------------------|-------------------|--------------|
| De-energized | 110 Ω | 4.07 V | In ink — no transfer |
| Energized | 94 Ω (parallel) | 3.70 V | Out of ink — transfer! |

The Arduino controls the gate via digital pin 3. The LOIS voltage is read on analog pin A1.

---

## System Interactions: Arduino, Printer & Temperature Controller

The Arduino Mega acts as the central controller, coordinating three systems:

{% include figure image_path="/assets/images/projects/moda/moda-sequence-sketch.png" alt="MODA ink transfer sequence" caption="MODA control sequence: when the real LOIS goes low, the melt timer starts and the simulated LOIS holds the printer back. After the timer expires, the simulated LOIS drops and the printer initiates the ink transfer." %}

### Arduino ↔ Omega Temperature Controller (RS485 / MODBUS ASCII)

The Omega CN7833 supports remote setpoint changes via **RS485** using the **MODBUS ASCII** protocol over a single shielded twisted-pair cable. This is what allows the Arduino to dynamically raise the supply reservoir setpoint from 80 °C to 125 °C when the LOIS goes low, and lower it back to 80 °C after the transfer completes.

A **TTL-to-RS485 converter** (MAX485-based) interfaces between the Arduino's UART and the twisted pair. MODBUS ASCII messages are constructed and sent as text frames — for example, writing to address `0x1001` (the setpoint register) with the value `0x04E2` (1250 in decimal, representing 125.0 °C):

```
:06100104E2[LRC]
```

The **Longitudinal Redundancy Check (LRC)** is appended to every message as an error check, calculated by summing each data byte and taking the two's complement. The Arduino script includes a `calculateLRC()` function that handles this automatically.

### Arduino ↔ 5800 Printer (LOIS Control)

As described above, the Arduino reads the real LOIS voltage on A1 and drives the MOSFET gate on pin 3 to control the simulated LOIS sent to the printer. The full control sequence is:

1. **Holding:** Supply reservoir at 80 °C. Simulated LOIS = in ink (MOSFET off → 4.07 V).
2. **LOIS drops below 3.85 V:** Melt timer starts. Setpoint commanded to 125 °C via RS485. Simulated LOIS held high to block the printer from initiating a transfer.
3. **Melt timer expires:** Simulated LOIS drops low (MOSFET on → 3.70 V). Printer sees out-of-ink and initiates the ink transfer normally.
4. **LOIS satisfied (>4.0 V):** Printer stops the transfer. Setpoint commanded back to 80 °C.

{% include figure image_path="/assets/images/projects/moda/ink-transfer-chart.png" alt="Ink transfer dynamics" caption="A normal ink transfer: supply reservoir pressurizes above 2 PSI to open the check valve, ink flows until the LOIS is satisfied, then pressure vents. Typical transfer takes 20–30 seconds." %}

{% include figure image_path="/assets/images/projects/moda/pneumatic-diagram.png" alt="5800 pneumatic/ink flow diagram" caption="5800 ink control module: Solenoid 3 (purple) directs the high pump output to the supply reservoir to initiate an ink transfer." %}

---

## Custom Arduino Shield

All the interfacing circuitry was built onto a **custom protoboard shield** that stacks directly on the Arduino Mega. The shield consolidates three functional areas:

{% include figure image_path="/assets/images/projects/moda/arduino-shield-photo.jpg" alt="Custom Arduino shield photo" caption="Custom Arduino Mega shield with RS485 module (top), LOIS reading circuit (left), and LOIS simulation circuit (right)." %}

{% include figure image_path="/assets/images/projects/moda/arduino-shield-schematic.png" alt="Arduino shield schematic" caption="Arduino shield schematic: RS485 TTL converter (top), LOIS voltage divider and A1 measurement (left), MOSFET-based LOIS simulator (right)." %}

**1 — RS485 Interface (top of shield)**  
The MAX485-based TTL-to-RS485 module is mounted at the top of the shield and wired to the Arduino's hardware Serial port. Pull-up, pull-down, and 120 Ω termination resistors are included to minimize noise on the twisted pair.

**2 — Real LOIS Measurement (left side)**  
A 12 V supply from the HP DC power supply feeds a 220 Ω + LOIS series divider, replicating the original printer circuit. A second divider (1 MΩ / 470 kΩ) scales the voltage into the Arduino's 0–5 V analog range. Pin A1 reads this value continuously.

**3 — Simulated LOIS Output (right side)**  
A 2N7000BU N-channel MOSFET is driven by digital pin 3. When the gate is low, only a 110 Ω resistor bridges the LOIS connector (in-ink signal). When the gate goes high, an additional 570 Ω resistor is switched in parallel, dropping the equivalent resistance to 94 Ω and pulling the simulated voltage below the printer's 3.85 V threshold.

---

## Test Results

The MODA prototype was tested at three ink consumption rates (Low: 0.35 ml/min, Medium: 0.72 ml/min, High: 1.44 ml/min) with progressively shorter melt timers. Each condition ran for 1.5–2.5 hours to confirm sustained stability across multiple ink transfers.

### Key Findings

**The minimum viable melt timer was far shorter than expected.** Original estimates assumed 1–5 minutes would be needed to melt enough ink for a transfer. In practice, successful ink transfers occurred with melt timers as short as **15–30 seconds** across all printing rates.

| Case | Min Melt Timer (no fault) | Avg. Ink Consumption |
|------|--------------------------|----------------------|
| Low (0.35 ml/min) | 30 sec | 0.36 ml/min |
| Medium (0.72 ml/min) | 15 sec | 0.72 ml/min |
| High (1.44 ml/min) | 10 sec | 1.44 ml/min |

Higher ink consumption rates tolerate shorter melt timers because ink transfers occur more frequently — there is less time for the supply reservoir to cool between cycles, so residual heat reduces the energy needed for the next melt.

**The ink inside the supply reservoir heats much more slowly than the reservoir wall.** With the holding temperature at 80 °C, the ink interior took over 75 minutes to approach 75 °C during the heat-up test — well below the reservoir wall setpoint. This slow response is due to the low thermal conductivity of the hot-melt ink.

**Temperature drop in the primary reservoir during ink transfer is negligible.** Ink transferred from the supply reservoir at ~85–95 °C into the primary reservoir at 125 °C caused only a **0.4 °C dip** in the primary reservoir temperature — no measurable impact on jetting performance.

**Ink transfer faults have a recognizable signature.** In cases where the melt timer was too short, the preceding transfer partially fills the primary reservoir (lower peak LOIS voltage), followed by a fault. After operator reset, the first successful transfer overfills slightly due to the depressurization of the supply reservoir.

### Conclusion

A melt-on-demand scheme on the 5800 is viable with only **software changes** needed on a production printer — no hardware modifications beyond the addition of fins to the supply reservoir. A **30-second melt timer** at an **80 °C holding temperature** is sufficient across all tested printing conditions. The technique is ready to be applied to next-generation print head development.
