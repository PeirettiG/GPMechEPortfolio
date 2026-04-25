---
permalink: /coin-dispenser/
title: "Laundry Coin Dispenser"
header:
  image: /assets/images/projects/coin-dispenser/full-3.jpg
  caption: "Progression of my 3D-printed quarter dispenser"
toc: true
toc_label: "Contents"

gallery:
  - url: /assets/images/projects/coin-dispenser/prototype-1.jpg
    image_path: /assets/images/projects/coin-dispenser/prototype-1.jpg
    alt: "placeholder image 1"
    title: "Image 1 title caption"
  - url: /assets/images/projects/coin-dispenser/prototype-2.jpg
    image_path: /assets/images/projects/coin-dispenser/prototype-2.jpg
    alt: "placeholder image 2"
    title: "Image 2 title caption"
  - url: /assets/images/projects/coin-dispenser/gate-cutaway.png
    image_path: /assets/images/projects/coin-dispenser/gate-cutaway.png
    alt: "placeholder image 3"
    title: "Image 3 title caption"
  - url: /assets/images/projects/coin-dispenser/gate-isometric.png
    image_path: /assets/images/projects/coin-dispenser/gate-isometric.png
    alt: "placeholder image 4"
    title: "Image 4 title caption"

---

**Year:** 2022  
**Skills:** Product Design · SolidWorks CAD · 3D Printing (SLA) · Prototyping · DFMA

---

## Easily store and dispense quarters for your Coin-Operated Laundry Machines

{% include figure image_path="/assets/images/projects/coin-dispenser/full-1.jpg" caption="Full shot of the quarter dispenser" class="align-right" %}

This quarter dispenser can store your collection of laundry quarters and conveniently hand them to you comfortably with the turn of a knob It features a storage space for up to 36 quarters, window slits to view how many are in storage, and a handy indicator panel to show how many loads of laundry you have left before you need to get more quarters. 

{% include figure image_path="/assets/images/projects/coin-dispenser/full-2.jpg" caption="Close-up on the indicator display with raised lettering and slotted viewing window." class="align-right" %}

Here's how it functions:
Insert multiples of six quarters into the opening at the top of the dispenser.
Watch the level of the quarters rise and show you how many loads of laundry you can purchase
​When its time to wash or dry your clothes, simply turn the knob to rotate the gate within.
As you spin, the quarters will fall into the gate, and then into your hand. Now, you no longer have to wonder how many quarters you have for laundry or separate them out individually. The quarter dispenser will store them neatly for you and yield them at your convenience!

{% include video id="4Lzl_saOc-c" provider="youtube" %}

## Problem Statement

The inspiration for this project came from my own personal problem. I lived in an apartment that used coin operated washing machines. 
Tracking and collecting quarters for coin-operated laundry machines was very inconvenient, and I often found myself with an odd number of quarters which wasn't enough to do Laundry. Each laundry cycle costs $1.50 (6 quarters), bank and office access are limited, and a coin shortage made quarters especially scarce. 
Furthermore, digging around in a ziploc bag for quarters was cumbersome and there is no easy way to tell how many loads I could do with the number of quarters left.
I needed a device that could solve my storage, tracking, and dispensing problem.

## Design Requirements

- Display remaining quantity of quarters in storeage
- Dispense exactly 6 quarters per cycle in a single motion
- Entirely mechanical — no motors or microcontrollers
  - This is a self-imposed restriction. Relying on a microcontroller to spin a dispenser a fixed number of times felt like cheating. Plus, it would require batteries or wall power.
- All components must be 3D-printable



## Idea Conception and Creation

{% include figure image_path="/assets/images/projects/coin-dispenser/comparison.jpg" alt="Comparison of existing quarter dispensers" caption="Existing quarter organizer products on the market" class="align-left" %}

I went through different stages of conception. I drew a few ideas in my notebook, and looked for inspiration from other coin dispensers. Many were meant to only dispense one at a time and were spring loaded. They probably work for bank tellers or for returning change, but I wanted a device that dispenses 6 at a time. I also found some coin sorters that can help you count out dollars or multiples of 10 coins. This seemed like a good place to start. My hope was that I could print something similar and that, in my version, quarters can roll down from the top to the bottom. That didn't end up working. The quarters didn't roll down in the way I wanted to. It looks like this tool is meant for easily counting a large stack of quarters. ​

{% include figure image_path="/assets/images/projects/coin-dispenser/organizer-tray.jpg" alt="Organizer tray" caption="Common coin organizer tray — functional but no dispensing mechanism" class="align-right"%}

In that case, I returned to the idea generation stage. I had a complete list of requirements, I thought of "what if the quarter groups are stacked on top of each other, and a door or gate can let in only one through the opening at a time?" Then the user could either pull a lever or twist a knob to dispense the quarters. The storage area could have a window or slotted walls that display how full or empty it is. Beside the window, would be an indicator panel to tell the user how many loads of laundry could be done. 

{% include gallery class = "full" layout = "half" %}

## Prototyping the dispenser gate

This is the first prototype that I made of the dispenser gate. It consists of two halves of a shell and a semi-circular coin gate. When designing this prototype, it seemed obvious that the shell needed to be split down the middle to allow the gate to be placed within. If it didn't end up working well, the ability to open the gate up would be useful to remove any stuck coins. This is a design feature that persisted through future versions. 

As the gate spins, an angled surface intersects the mating edges of the bottom two coin stacks, separating the last group from the second to last. Then as the gate continues to spin, it opens to the bottom, and the coins fall out. I was quite surprised when this worked so well! The gate spins freely without bearings. It can only hold 12 quarters, but that was sufficient for testing the function. It successfully holds more than 6 quarters. It dispenses 6 at a time. And, all the pieces were made in the 3d printer. ​

{% include video id="ExuNYJFyOUc" provider="youtube" %}

Now, it came time to make a larger version. This would have the same quarter gate, but I wanted to make it taller to hold the full capacity of quarters. At the same time, I was modeling what the full dispenser would look like and how the indicator panel would sit. A concern of mine was that the combined weight of 24-30 quarters would be too heavy for the shafts of the gate. This could stop the gate from turning because it can't lift the coins. Or, the worst case, is that it would break the gate or split the shell. For that reason, I increased the diameter of the gate shaft, and added a fillet where they meet to increase the strength. 
​​
{% include figure image_path="/assets/images/projects/coin-dispenser/gate-closeup.png" alt="Organizer tray" class="align-right"%}



## Knob Design

The Knob was also a custom part. I had an image of the knob I wanted to make, and decided to model it in SolidWorks. It was a simple part driven by some sketches to get the shape that I wanted. Then I extruded to full thickness, added a face fillet to smooth it out. Then I shelled it to reduce the weight, and added a hexagonal cut-out to accept the gate. 

{% include figure image_path="/assets/images/projects/coin-dispenser/knob-front.png" alt="Knob front view" caption="Knob — front view" %}

{% include figure image_path="/assets/images/projects/coin-dispenser/knob-back.png" alt="Knob back view" caption="Knob — back view showing hexagonal socket" %}



## DFMA & SolidWorks tips

Part of the goal of the project was manufacturing this on the SLA printers at work. We have several Prusa SL1s printers. They make parts out of a photopolymer resin, a resin that hardens with exposure to UV light. By selectively exposing areas of the display, the part is printed layer by layer. 

The build volume of the printer is limited to 127mm L x 180 mm W x 180mm H. This means that parts must fit within this bounding box if they are to print successfully. The dispenser was already too tall So I took the shell and split it into 5 pieces: 4 quadrants of the main chamber, and the separate indicator panel. The horizontal split allowed me to fit the pieces within the height of the printer, and the vertical split gave me access to insert the gate during assembly. The indicator panel was printed in one piece diagonally. 

When designing the shell, I modeled the entire part, then used split bodies to cut the pieces apart. But I also had to keep in mind how I would assemble the dispenser. Having 4 to 5 separate parts without any mating features will make it very difficult to assemble and be confident that all pieces are aligned.

One way to fix that is to add a lip on one half of the part and a corresponding groove in the other. That way they will fit in only one way. At the beginning of this project, I was manually defining sketches and extruding cuts to make the grooves & notches in each part. But that takes too much time and is liable introduce mistakes if you want to make changes.

Then I discovered a feature in Solid Works that adds it automatically!
Enter, the Lip & Groove feature.

You can find it by going to Insert > Fastening Feature > Lip & Groove.
You can add either lip, groove, or both. Start by selecting the bodies for each Lip & Groove. Then select the Face and the edge for which the feature will be added. This is typically the mating face and an internal edge of the part. Then customize the dimensions of the lip and groove. You can edit the lip height, thickness, draft angle, and clearances!
To connect the Indicator panel to the rest of the body, I took the two rear portions of the shell and added larger notches that could receive matching protruding tabs from the panel.

For assembly, I placed the pieces together and secured them with super glue. 
​

## Manufacturing and Printing in resin

Printing in SLA is a very exciting additive manufacturing method, but it also brings its own set of challenges and requires specific design considerations. The way that it works uses a build platform where every print has its first layers cured to. It is submerged in a reservoir bath of the photopolymer resin, where the bottom surface is a transparent film. Now, every printer will have its own way of selectively curing resin layer by layer to produce the part. Many use a high powered laser and trace the path across the screen to cure the layer. The greater the area to be exposed, the longer the laser has to travel to expose the current layer. The Prusa SL1s uses a digital LCD display and high powered UV backlights to display an image of the pattern for each layer. One advantage of this design is that the entire layer can be exposed for a constant time regardless of the total area exposed. This means that the only factor driving print time is the maximum height of the part in the printer. 

Just like FDM printers, the parts made in SLA printers need supports to print properly. However, the unique design of them demonstrates the difference in their purpose. The SLA parts are printed upside down, slowly emerging from the resin bath. As each layer prints, the newly cured layer is stuck to both the previous layer and the transparent bottom film. The printer then separates the new layer from the bottom of the tank and this can impart 'peel forces' onto the part. They can disturb, warp, or even break sections of the part. So the supports serve to connect the part to the build platform as well as the current layer to the previous layers. ​
​​
Light supports can be easily removed from the part with few tools, but they also leave marks on the surface. Small little dots will cover the entire surface where you supported your part. Therefore, in cases where aesthetics are concerned, a good designer should leave the visible side away from the build platform. I did that with the knob and the indicator panel, where I didn't want the important surfaces to be marred by witness marks. So, I pointed the smooth surface of the knob and the letters of the indicator panel to the sky. 

All parts were printed on Prusa SL1s SLA printers using photopolymer resin. Parts were oriented to minimize visible support marks on aesthetic surfaces.

{% include figure image_path="/assets/images/projects/coin-dispenser/early-1.jpg" alt="Early print" caption="Early prototype print — Nov 2022" %}

{% include figure image_path="/assets/images/projects/coin-dispenser/early-2.jpg" alt="Early print assembly" caption="Early prototype assembly" %}

{% include figure image_path="/assets/images/projects/coin-dispenser/early-3.jpg" alt="Early prototype test" caption="Early prototype test" %}

{% include figure image_path="/assets/images/projects/coin-dispenser/final-1.jpg" alt="Final print" caption="Final printed parts" %}

{% include figure image_path="/assets/images/projects/coin-dispenser/final-2.jpg" alt="Final assembled dispenser" caption="Final assembled quarter dispenser" %}
