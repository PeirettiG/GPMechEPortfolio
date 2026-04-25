---
permalink: /coin-dispenser/
title: "Laundry Coin Dispenser"
header:
  image: /assets/images/projects/coin-dispenser/full-3.jpg
  caption: "Finished 3D-printed quarter dispenser"
toc: true
toc_label: "Contents"
---

**Year:** 2022  
**Skills:** Product Design · SolidWorks CAD · 3D Printing (SLA) · Prototyping · DFMA

---

## Problem Statement

Tracking and collecting quarters for coin-operated laundry machines is inconvenient. Each laundry cycle costs $1.50 (6 quarters), bank and office access are limited, and a coin shortage made quarters especially scarce. A mechanical storage and dispensing solution was needed.

## Design Requirements

- Display remaining quarter quantity
- Dispense exactly 6 quarters per cycle in a single motion
- Entirely mechanical — no motors or microcontrollers
- All components must be 3D-printable

---

## Existing Solutions

{% include figure image_path="/assets/images/projects/coin-dispenser/comparison.jpg" alt="Comparison of existing quarter dispensers" caption="Existing quarter organizer products on the market" %}

{% include figure image_path="/assets/images/projects/coin-dispenser/organizer-tray.jpg" alt="Organizer tray" caption="Common coin organizer tray — functional but no dispensing mechanism" %}

---

## Core Mechanism

The dispenser uses a rotating semi-circular gate. As the gate spins, an angled surface separates a group of coins, then opens downward to dispense them. A single knob turn drives the full cycle.

{% include figure image_path="/assets/images/projects/coin-dispenser/prototype-1.jpg" alt="Early gate prototype" caption="Early gate mechanism prototype" %}

{% include figure image_path="/assets/images/projects/coin-dispenser/gate-cutaway.png" alt="Gate cutaway view" caption="Gate mechanism — cutaway view showing coin separation" %}

{% include figure image_path="/assets/images/projects/coin-dispenser/prototype-2.jpg" alt="Gate prototype isometric" caption="Gate prototype" %}

{% include figure image_path="/assets/images/projects/coin-dispenser/gate-isometric.png" alt="Gate isometric CAD" caption="Gate mechanism — isometric CAD view" %}

{% include figure image_path="/assets/images/projects/coin-dispenser/gate-closeup.png" alt="Gate closeup" caption="Finished gate — closeup" %}

---

## Knob Design

A custom knob with a hexagonal cutout connects directly to the gate shaft, enabling one-handed dispensing.

{% include figure image_path="/assets/images/projects/coin-dispenser/knob-front.png" alt="Knob front view" caption="Knob — front view" %}

{% include figure image_path="/assets/images/projects/coin-dispenser/knob-back.png" alt="Knob back view" caption="Knob — back view showing hexagonal socket" %}

---

## Shell & Assembly

The outer shell was split into 5 pieces to fit within the printer build volume (127mm × 180mm × 180mm). Lip & groove features align and secure the pieces.

{% include figure image_path="/assets/images/projects/coin-dispenser/shells-slicer.png" alt="Shell pieces in slicer" caption="Shell pieces oriented in Prusa slicer software" %}

{% include figure image_path="/assets/images/projects/coin-dispenser/notch.png" alt="Assembly notch feature" caption="Lip feature for shell alignment" %}

{% include figure image_path="/assets/images/projects/coin-dispenser/tab.png" alt="Assembly tab feature" caption="Groove feature for shell alignment" %}

---

## Indicator Panel

The indicator panel uses raised lettering and a slotted viewing window to display how many loads remain.

{% include figure image_path="/assets/images/projects/coin-dispenser/full-1.jpg" alt="Indicator panel view" caption="Indicator display panel" %}

{% include figure image_path="/assets/images/projects/coin-dispenser/full-2.jpg" alt="Dispenser full view" caption="Quarter dispenser — full view" %}

---

## Manufacturing

All parts were printed on Prusa SL1s SLA printers using photopolymer resin. Parts were oriented to minimize visible support marks on aesthetic surfaces.

{% include figure image_path="/assets/images/projects/coin-dispenser/early-1.jpg" alt="Early print" caption="Early prototype print — Nov 2022" %}

{% include figure image_path="/assets/images/projects/coin-dispenser/early-2.jpg" alt="Early print assembly" caption="Early prototype assembly" %}

{% include figure image_path="/assets/images/projects/coin-dispenser/early-3.jpg" alt="Early prototype test" caption="Early prototype test" %}

{% include figure image_path="/assets/images/projects/coin-dispenser/final-1.jpg" alt="Final print" caption="Final printed parts" %}

{% include figure image_path="/assets/images/projects/coin-dispenser/final-2.jpg" alt="Final assembled dispenser" caption="Final assembled quarter dispenser" %}
