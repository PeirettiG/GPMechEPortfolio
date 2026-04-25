---
permalink: /arduino-controller/
title: "Arduino Minecraft Controller"
toc: true
toc_label: "Contents"
---

**Year:** 2020 — ME360 Product Design, Boston University  
**Skills:** Arduino · Accelerometer · Gyroscope · Python · Embedded Systems · Product Design

---

## Overview

This ME360 project aimed to allow a user to **control a virtual environment (Minecraft) using physical movements and real-world inputs**, rather than a keyboard and mouse. The controller maps body motion to in-game actions using an accelerometer, gyroscope, and a button.

---

## Technical Components

| Component | Function |
|-----------|----------|
| Accelerometer (in "Steve" model) | Forward/back/left/right movement + jump |
| Gyroscope (in headband) | Camera/look direction |
| Single button | Hit / break objects |
| Arduino microcontroller | Sensor data collection |
| Python script | Parse Arduino data → keyboard commands |

---

## How It Works

### Movement Controls
The accelerometer is embedded in a model of "Steve" (Minecraft character). Tilting the model controls character movement:
- **Forward tilt** → walk forward
- **Left tilt** → move left
- **Upward acceleration** → jump

### Camera Control
A headband-mounted gyroscope tracks head rotation for 3D camera movement. The camera pan commands were scaled to allow 180° in-game rotation while keeping the computer screen visible to the user.

### Interaction
A single button enables hitting and breaking objects in the game environment.

---

## Reflection

The project functioned successfully but highlighted some limitations:

- Users face a **learning curve** when combining accelerometer movement and gyroscope camera simultaneously
- **Missing features:** inventory management and crafting were cut due to time constraints, despite the project exceeding base assignment requirements
- Future improvements would include additional buttons for inventory and a more intuitive body-mapping scheme
