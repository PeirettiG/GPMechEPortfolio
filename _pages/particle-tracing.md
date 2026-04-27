---
permalink: /particle-tracing/
title: Droplet Trajectory Simulation using Lagrangian Particle Tracing
header:
  overlay_image: /assets/images/projects/particle-tracing/velocity-mag-r2l.png
  overlay_filter: 0.5
toc: true
toc_label: Contents
excerpt: 'Built a 2D COMSOL CFD model of an inkjet printhead enclosure and a MATLAB Lagrangian particle tracker to determine whether an internal cooling fan causes lateral droplet deflection.'
---

**Year:** 2024 — Markem-Imaje  
**Skills:** CFD (COMSOL) · Lagrangian Particle Simulation · MATLAB · Fluid Dynamics · Inkjet Systems

---

## Background

In industrial printing applications, it is important to precisely control the landing location of inkjet droplets to make a coherent image. However, during the travel time of the droplet there are several sources of disturbance that can change the path of the droplet mid air. 

Two sources of air disturbance studied in this project:
- Drafts and air currents created by a moving printing substrate
- Printhead fan to prevent dust ingress

A question that I wanted to solve was how does the fan's airflow deflect droplets as they travel from the nozzle to the substrate?

To answer this, a 2D steady-state CFD model of the enclosure's internal airflow was built in COMSOL, and the resulting velocity field was imported into MATLAB to simulate individual droplet trajectories using a Lagrangian particle tracking algorithm.

---

## CFD Model Setup

The model represents a cross-section of the printhead enclosure: a **100 mm × 5 mm** outer channel where the 5 mm dimension corresponds to the throw distance (nozzle-to-substrate gap). Laminar flow was assumed throughout.

{% include figure image_path="/assets/images/projects/particle-tracing/boundary-conditions.png" alt="COMSOL model boundary conditions" caption="Boundary conditions for the 2D COMSOL model. Fan inlets are specified as velocity inlets; the substrate is modeled as a sliding wall moving at print speed." %}

**Boundary conditions:**

| Boundary                | Condition                                   |
| ----------------------- | ------------------------------------------- |
| Left fan inlet          | Velocity inlet — ~1.5m/s                    |
| Right fan inlet         | Velocity inlet — ~1 m/s                     |
| Substrate (bottom wall) | Moving wall — 20 to 150 m/min (print speed) |
| Remaining walls         | No-slip                                     |

The asymmetric fan inlet velocities reflect the actual measured fan output on each side of the enclosure. The substrate moves in one of two directions depending on print orientation: **left-to-right (L2R)** or **right-to-left (R2L)**.

---

## CFD Results

### Left-to-Right Substrate Motion

{% include figure image_path="/assets/images/projects/particle-tracing/velocity-mag-l2r.png" alt="Velocity magnitude — L2R substrate direction" caption="Velocity magnitude field with substrate moving left-to-right. The fan airflow exits the enclosure at approximately 30° and deflects along the substrate toward the right." %}

With the substrate moving left-to-right, the fan flow consolidates into a single jet that exits the enclosure at a **~30° angle** and deflects downstream along the substrate. The flow pattern is relatively symmetric and organized.

### Right-to-Left Substrate Motion

{% include figure image_path="/assets/images/projects/particle-tracing/velocity-mag-r2l.png" alt="Velocity magnitude — R2L substrate direction" caption="Velocity magnitude field with substrate moving right-to-left. The central jet splits, creating two asymmetric flow regions and recirculation zones near the nozzle." %}

With the substrate moving right-to-left, the flow is significantly more complex. The central jet splits into two branches, creating **recirculation zones** near the nozzle exit. This asymmetry exposes different nozzle positions to different crossflows, which could deflect droplets laterally by different amounts depending on their position along the nozzle array.

---

## Lagrangian Particle Tracking

### Method

1) The COMSOL velocity field was exported to MATLAB as a mesh of node positions and velocity vectors. For each time step of the droplet simulation, the local fluid velocity was found by identifying the nearest mesh node for the droplet's position.

2) The Reynold's number for a spherical droplet was calculated by using the relative velocity of the droplet and the surrounding fluid.

{% include figure image_path="/assets/images/projects/particle-tracing/reynolds-num.png" alt="Reynolds number calculation" caption="Particle Reynolds number calculated from the relative velocity between the droplet and the surrounding fluid." %}

3) The drag coefficient on the droplet was computed using the **Schiller-Neumann** correlation shown below.

{% include figure image_path="/assets/images/projects/particle-tracing/Cd-calc.png" alt="Drag coefficient formula" caption="Schiller-Neumann drag coefficient: valid for Re < 1000. Reduces to Stokes drag at low Re." %}

4) Then the force balance is solved and to calculate the change in the velocity of the particle. 

{% include figure image_path="/assets/images/projects/particle-tracing/delta-u.png" alt="Droplet equation of motion" caption="Force balance on the droplet. Acceleration is proportional to the velocity difference between fluid and droplet, modified by the drag coefficient." %}

5) Then update the particle velocity and continue until the particle position hits the substrate. 


## Results

Here is a sample simulation result plotted in Matlab. The paths of droplets from different jetpack locations are plotted for the worst case scenario.

{% include figure image_path="/assets/images/projects/particle-tracing/matlab-trace-r2l.png" alt="Simulated droplet trajectories — R2L direction" caption="Simulated droplet trajectories across the nozzle array for R2L substrate motion. Lateral deflection varies by nozzle position due to the asymmetric flow field." %}

| Condition | Lateral Deflection (Δ) |
|-----------|------------------------|
| No fan (baseline) | 0 μm |
| R2L + fan, 20 m/min | 10 μm |

---

## Conclusion

The fan contributes a measurable but relatively small lateral droplet deflection (~10 μm range). The dominant explanation for the observed zippering is **nozzle angle deviation** between jetpack assemblies (±10 mrad produces ~130 μm of error — more than 13× larger than the fan effect). The CFD and particle tracing work ruled out the fan as the primary cause and redirected investigation toward mechanical alignment tolerances in the jetpack assembly.
