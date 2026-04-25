---
permalink: /air-motor/
title: "Non-Metallic Air-Driven Motor"
header:
  image: /assets/images/projects/air-motor/exploded-view.jpg
  caption: "Exploded CAD view of the pneumatic stepper motor"
toc: true
toc_label: "Contents"
---

**Year:** 2021 — Boston University Senior Design Capstone  
**Skills:** Mechanical Design · SolidWorks · 3D Printing · Pneumatic Systems · Arduino

---

## Project Overview

This was my senior design capstone project at Boston University, completed for the **National Emerging Infectious Diseases Laboratory (BU NEIDL)** — a BSL-4 facility that studies dangerous pathogens.

The technician operating an MRI machine in a BSL-4 lab must manually adjust the position of a specimen chamber according to the radiologist's instructions. Because the facilities are separated by 20+ feet, this creates significant inefficiency. The goal was to design a motor that could remotely position the chamber with precision.

---

## Key Requirements

| Requirement | Specification |
|-------------|---------------|
| Fuel source | Compressed air (already available in lab) |
| Remote control | 10–20 feet range |
| Step resolution | 5°–10° per step |
| Materials | Non-ferromagnetic, MR-safe only |

---

## Prior Art

{% include figure image_path="/assets/images/projects/air-motor/pneustep.jpg" alt="PneuStep motor" caption="PneuStep (Johns Hopkins) — hypocycloidal gear design" %}

{% include figure image_path="/assets/images/projects/air-motor/pneumatic-stepper.jpg" alt="Pneumatic stepper reference" caption="Reference pneumatic stepper motor design" %}

{% include figure image_path="/assets/images/projects/air-motor/10mm-motor.png" alt="10mm motor design" caption="Chen, Mershon & Tse alternating pressure/vacuum push-rod system" %}

---

## Design Innovation

The team drew inspiration from a **Pilot G-2 ballpoint pen's clicking mechanism**, which rotates the ink cartridge incrementally with each press. This concept was adapted to use a single air piston to produce a 10° rotational step without a gear reduction.

{% include figure image_path="/assets/images/projects/air-motor/diagram-1.png" alt="Mechanism diagram" caption="Pen-click mechanism concept adapted for pneumatic actuation" %}

{% include figure image_path="/assets/images/projects/air-motor/diagram-2.png" alt="Mechanism diagram 2" caption="Motor mechanism schematic" %}

{% include figure image_path="/assets/images/projects/air-motor/diagram-3.jpg" alt="Motor diagram" caption="Motor assembly diagram" %}

{% include figure image_path="/assets/images/projects/air-motor/diagram-4.png" alt="Control diagram" caption="Arduino solenoid valve control schematic" %}

---

## Technical Specifications

- **Actuation:** Single air piston
- **Control:** Arduino-controlled solenoid valve
- **Operating pressure:** 20–43 psi
- **Step angle:** 10°
- Motor jammed above **43 psi** due to rapid piston extension
- Below **20 psi**, compressor couldn't restore pressure between strokes

---

## Prototypes

{% include figure image_path="/assets/images/projects/air-motor/prototype-1.jpg" alt="3D printed prototype" caption="3D-printed prototype — scale testing" %}

{% include figure image_path="/assets/images/projects/air-motor/prototype-2.jpg" alt="Final prototype" caption="Final prototype assembly" %}

{% include figure image_path="/assets/images/projects/air-motor/team-photo.jpg" alt="Team photo" caption="Senior design team" %}

---

## Build Process

{% include figure image_path="/assets/images/projects/air-motor/build-1.jpg" alt="Build photo 1" caption="Motor build — assembly stage" %}

{% include figure image_path="/assets/images/projects/air-motor/build-2.jpg" alt="Build photo 2" %}

{% include figure image_path="/assets/images/projects/air-motor/build-3.jpg" alt="Build photo 3" %}

{% include figure image_path="/assets/images/projects/air-motor/build-4.jpg" alt="Build photo 4" %}

{% include figure image_path="/assets/images/projects/air-motor/build-5.jpg" alt="Build photo 5" %}

{% include figure image_path="/assets/images/projects/air-motor/build-6.jpg" alt="Build photo 6" %}

{% include figure image_path="/assets/images/projects/air-motor/build-7.jpg" alt="Build photo 7" %}

{% include figure image_path="/assets/images/projects/air-motor/build-8.jpg" alt="Build photo 8" %}
