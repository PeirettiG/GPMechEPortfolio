---
permalink: /ventus/
title: Integration and testing of novel gas pump & Closed-Loop Vacuum Control
header:
  overlay_image: /assets/images/projects/ventus/ventus-and-printer.jpeg
  overlay_filter: 0.5
  caption: Ventus Pump integrated to printer
toc: true
toc_label: Contents
excerpt: 'Integrated a new piezoelectric vacuum pump into an industrial printhead as a drop-in replacement for the legacy pump. Project led to multi-year thermal stress reliability testing'
---

**Year:** 2024 — Markem-Imaje  
**Skills:** Fluid dynamics · Control theory · Electronics Design · Measurement & Experimentation · Reliability Testing

---

![Ventus Smart Pump Module mounted on printer]({{ site.baseurl }}/assets/images/projects/ventus/ventus-and-printer.jpeg)
*Smart Pump Module (SPM) mounted on the custom bracket I designed.*

## Overview

This project evaluated a new piezoelectric vacuum pump (the "Ventus" pump) as a candidate replacement for a legacy diaphragm pump used in an industrial printhead. My role was to do the mechanical and electrical integration work needed to make the new pump operate inside an existing printer chassis, get it talking to a host PC, and tune its closed-loop controller against the printer's existing pneumatic disturbances.

I then replicated the setup 4 times to be used for accelerated life testing. 

![Ventus Smart Pump Module mounted on custom bracket]({{ site.baseurl }}/assets/images/projects/ventus/ventus-spm-bracket.jpeg)
*Smart Pump Module (SPM) mounted on the custom bracket I designed.*

---

## Mechanical Integration

The new pump came as a "Smart Pump Module" (SPM) which was a small board that includes the pump, drive electronics, and a serial interface in one package. It needed to mount in the same chassis location as the legacy pump while interfacing with the printer's existing pneumatic plumbing.

I designed a **custom mounting bracket** that:

- Bolts to the printer chassis at the legacy pump's existing mounting points (no chassis modifications)
- Holds the SPM with M2 hardware vertically to not allow condensation to ruin the pump
- Includes a **neoprene isolation pad** between the SPM and the bracket to prevent shorts to the metal chassis and dampen the pump's mechanical vibrations
- Routes the SPM's pneumatic ports to align cleanly with the printer's existing tubing

I also specified replacing the SPM's stock thin O-rings with same-size **Viton** rings, because the originals were susceptible to ozone attack — a real concern given the pump runs continuously over the life of the printer.

![SPM mounted on the printhead with pneumatic connections]({{ site.baseurl }}\assets\images\projects\ventus\02_spm_pneumatic_connections.png)
*Pump SPM and bracket installed on the printhead with pneumatic and signal connections in place.*

---

## Electrical Integration

The smart pump module needed three external connections: power, a serial connection for control and telemetry, and a 0–3.3 V analog feedback signal from an external pressure sensor for closed-loop vacuum regulation.

### Power and Communications Harness

I built a custom harness that breaks out the SPM's pins into:

- **Power and ground** to a bench supply
- **UART (RX/TX) routed through an FTDI cable** to the lab PC, which presents the SPM as a virtual COM port for the manufacturer's control app
- **Analog input and analog ground** left as flying leads to connect to the pressure sensor signal conditioning board


### Pressure Sensor Signal Conditioning — and What Didn't Work

The SPM's analog input expects 0–3.3 V based on a pressure sensor, but the differential pressure sensors I had available to use had issues that needed to be fixed before they could be used with the pump module. 

For one, when using an voltage-output sensor (a 0–10 V model with 1000 Pa or 2500 Pa range options), it was discovered that connecting the sensor's output directly to the SPM's analog input caused the sensor's output voltage to fall. Even though the datasheet listed the sensor's output impedance as <5 Ω, the SPM input was loading it enough to produce a measurable error.

To fix this, I had to make a signal conditioning board:

- **Op-amp voltage follower** (TI LM358P) provides a high-impedance buffer so the sensor sees no load
- **3:1 voltage divider** on the buffer output scales the 0–10 V sensor signal down into the SPM's 0–3.3 V input range
- **10 kΩ pull-down** on the input side keeps the input near zero when during regular purging events create positive pressure and a negative voltage from the vacuum sensor.

![Schematic of the signal conditioning circuit]({{ site.baseurl }}\assets\images\projects\ventus\04_signal_conditioning_schematic.png)
*Signal conditioning circuit: voltage follower buffers the sensor output, then a divider scales it to the SPM analog input range.*

I worked with a colleague to package the circuit on small breadboards sized to fit within the footprint of the pressure sensor itself. Power was tapped from the sensor's own supply via spade connectors, and the conditioned output broke out to a 2-pin screw terminal so the harness could connect securely without solder joints in the field.

![Signal conditioning board mounted directly on the pressure sensor]({{ site.baseurl }}\assets\images\projects\ventus\05_signal_conditioning_mounted.jpeg)
*Completed signal conditioning circuit packaged onto the back of the pressure sensor.*

---

## Closed-Loop Tuning

With the SPM, harness, and sensor all integrated, I tuned the SPM's onboard PID controller using the manufacturer's app over the UART link. I used the following approach as recommended by my lead engineer as a starting point:

1. With Ki = Kd = 0, increased Kp until the loop began to oscillate at the setpoint, recording **Ku** (ultimate gain) and **Tu** (oscillation period)
2. Used the standard relationships to compute starting Kp and Ki values
3. Tuned Ki and Kd from there based on disturbance response, not just setpoint tracking

I then tested the system's response to a disturbance by pressurizing the volume and measuring the pump's ability to restor the vacuum. 

![Plot showing recovery from a disturbance event with the tuned PID parameters]({{ site.baseurl }}\assets\images\projects\ventus\purge-response.png)
*Recovery from a disturbance event with the tuned PID parameters. Vacuum returns to within ±10 Pa of setpoint in well under one second.*


---

## Replicated 4× for Life Testing

Once a single integrated unit was characterized and tuned, the same setup (bracket, harness, signal conditioning board, sensor, pneumatic connections) was replicated four times so that four printheads could be run in parallel inside an environmental chamber for accelerated life testing. 

I then lead and managed this accelerated life testing for multiple years involving regular data collection, processing, and analysis. 

---

## Skills Demonstrated

- **Mechanical integration:** Custom bracket design and fabrication, drop-in replacement of a legacy component without chassis modifications, vibration isolation, materials selection (Viton vs. standard elastomer for chemical compatibility).
- **Electronics design and debug:** Op-amp signal conditioning (voltage follower + divider + pull-down), impedance matching to high-Z analog inputs, current-loop receiver design, working through bad-component debug paths and supplier issues.
- **Harness and instrumentation:** Custom UART-to-USB harnesses via FTDI, pinout verification across sensor variants (a hard lesson in reading datasheets fully — the 4–20 mA and 0–10 V versions of the same sensor family had different pin assignments).
- **Closed-loop tuning:** Ziegler-Nichols starting point, disturbance-response-based refinement, trade-off characterization between steady-state power and recovery time.
- **Design for repeatability:** Producing an integration package that could be cleanly replicated four times for parallel life testing.