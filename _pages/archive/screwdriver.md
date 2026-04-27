---
permalink: /screwdriver/
title: "Screwdriver DFMA Analysis"
header:
  image: /assets/images/projects/screwdriver/disassembly.jpg
  caption: "Black & Decker LI2000 disassembly"
toc: true
toc_label: "Contents"
---

**Year:** 2018  
**Skills:** Product Deconstruction · DFMA · Mechanical Analysis

---

## Overview

This project is a detailed deconstruction and analysis of the **Black & Decker LI2000 pivot screwdriver**, examining its gear train, directional switch, pivot handle lock, and power/manual mode switch with a focus on Design for Manufacturing and Assembly (DFMA).

{% include figure image_path="/assets/images/projects/screwdriver/product.jpg" alt="Black & Decker LI2000" caption="Black & Decker LI2000 pivot screwdriver" %}

{% include figure image_path="/assets/images/projects/screwdriver/disassembly.jpg" alt="Disassembly" caption="Initial disassembly" %}

---

## Product Structure

{% include figure image_path="/assets/images/projects/screwdriver/product-structure.png" alt="Product structure diagram" caption="Product structure breakdown" %}

{% include figure image_path="/assets/images/projects/screwdriver/slide-2.png" alt="Component breakdown slide 2" caption="Component breakdown" %}

{% include figure image_path="/assets/images/projects/screwdriver/slide-3.png" alt="Component breakdown slide 3" %}

{% include figure image_path="/assets/images/projects/screwdriver/slide-4.png" alt="Component breakdown slide 4" %}

---

## Gear Train

The device uses **two sets of epicyclic (planetary) gear trains**, each with a gear ratio of 9:1, for a combined ratio of **81:1**. This design increases torque output while maintaining a linear motor-to-spindle orientation — ideal for a compact handheld tool.

{% include figure image_path="/assets/images/projects/screwdriver/internal-1.jpg" alt="Gear train photo 1" caption="Epicyclic gear train — first stage" %}

{% include figure image_path="/assets/images/projects/screwdriver/internal-2.jpg" alt="Gear train photo 2" caption="Epicyclic gear train — second stage" %}

---

## Forward / Backward Switch

The directional control is entirely mechanical. A rotating plastic piece mounted on the battery wires contains metal connectors spanning a semicircular arc. When the trigger is pressed, metal contacts complete the circuit with reversed polarity depending on rotational position.

{% include figure image_path="/assets/images/projects/screwdriver/internal-3.jpg" alt="Direction switch" caption="Forward/backward switch mechanism" %}

{% include figure image_path="/assets/images/projects/screwdriver/internal-4.jpg" alt="Direction switch 2" %}

---

## Power / Manual Mode Switch

A white gear mechanism locks or frees the final planetary carrier:

- **Manual mode:** The gear meshes with the teeth on the final planetary carrier, allowing hand torque
- **Power mode:** The gear disengages, allowing full motor-driven operation

{% include figure image_path="/assets/images/projects/screwdriver/internal-5.jpg" alt="Power/manual mode switch" caption="Power/manual mode switch" %}

---

## Pivot Mechanism

The screwdriver pivots to three positions: straight, 45°, and 90°. Gear-shaped holes with one oversized tooth featuring a groove enable position locking when the pin is released.

{% include figure image_path="/assets/images/projects/screwdriver/internal-6.jpg" alt="Pivot mechanism" caption="Pivot mechanism" %}

{% include figure image_path="/assets/images/projects/screwdriver/internal-7.jpg" alt="Pivot lock" caption="Pivot lock detail" %}

{% include figure image_path="/assets/images/projects/screwdriver/internal-8.jpg" alt="Internal components" caption="Internal component layout" %}

---

## DFMA Highlights

- **Asymmetric indentations** prevent incorrect orientation during assembly
- **Motor-mounting grooves** constrain the motor precisely without fasteners
- **Single-orientation fittings** prevent assembly errors
- Overall component count is minimized; most parts serve multiple functions
