---
permalink: /open-loop-drive/
title: "Open-Loop Linear Drive with Stepper Motor"
toc: true
toc_label: "Contents"
---

**Year:** 2020 — ME460 Senior Design, Boston University  
**Skills:** Arduino · Stepper Motor Control · Linear Mechanisms · Embedded Systems

---

## Overview

This introductory ME460 Senior Design project is an **open-loop linear drive** powered by a stepper motor receiving commands from an Arduino Uno. Without position feedback, the system executes pre-programmed movement sequences based on step counts.

---

## Control System

| Component | Detail |
|-----------|--------|
| Controller | Arduino Uno with motor shield |
| Motor | Stepper motor |
| Power | Barrel connector to wall outlet |
| Communication | USB to PC for code flashing & serial monitor |

**Pin Configuration (Motor Shield):**

| Function | Pin |
|----------|-----|
| Primary coil direction | Digital 12 |
| Primary coil power | Digital 3 |
| Primary coil brake | Digital 9 |
| Secondary coil direction | Digital 13 |
| Secondary coil power | Digital 11 |
| Secondary coil brake | Digital 8 |
| Current sense (primary) | Analog 0 |
| Current sense (secondary) | Analog 1 |

---

## Physical Construction

The linear drive assembly consists of:

- Two smooth shafts for lateral stability
- One threaded rod driven by the stepper motor
- Threaded brass nut moved laterally by rod rotation
- Foam carriage with aluminum sliders and bushings
- Normally-open limit switch (breadboard-mounted)
- Foam core board base with motor support
- Assembly materials: hot glue, metal bearings, aluminum supports

---

## Versions

### Version 1
Commands motor movement in both directions using full and half-stepping sequences. Measures and logs current draw and displacement via serial monitor.

### Version 2
Adds limit switch input for automated sequences:
- Approach movements (8mm and 30mm displacements)
- Automatic direction reversal upon switch trigger
