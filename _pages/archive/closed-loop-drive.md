---
permalink: /closed-loop-drive/
title: "Closed-Loop DC Motor Drive"
toc: true
toc_label: "Contents"
---

**Year:** 2020 — ME460 Senior Design, Boston University  
**Skills:** Arduino · DC Motor Control · Closed-Loop Control · PID · Embedded Systems

---

## Overview

This project upgrades the [Open-Loop Linear Drive](/open-loop-drive/) by replacing the stepper motor with a **DC motor** and adding closed-loop RPM control. The underlying linear drive mechanism (threaded rod, smooth shafts, carriage) remains unchanged.

---

## Key Differences from Open-Loop Design

| Feature | Open-Loop (Stepper) | Closed-Loop (DC) |
|---------|---------------------|-----------------|
| Motor type | Stepper — discrete steps | DC — continuous rotation |
| Voltage | Step sequences | Continuously varied |
| Feedback | None | Chronometer RPM sensor |
| Speed control | Fixed step rate | PID algorithm |

---

## Control Algorithm

A closed-loop control algorithm continuously varies the voltage supplied to the DC motor. The system aims to keep the motor at a specific RPM under variable load and variable target speeds.

The Arduino code was substantially revised to:
1. Read RPM from a chronometer device attached to the motor shaft
2. Calculate error between target and actual RPM
3. Adjust motor voltage to minimize error

---

## System Description

- **Motor:** DC motor (replaces stepper)
- **Feedback:** Chronometer device on motor shaft providing pulse-based RPM reading
- **Controller:** Arduino Uno with motor shield
- **Linear mechanism:** Unchanged from Version 1 — threaded rod, smooth shafts, foam carriage with aluminum sliders
