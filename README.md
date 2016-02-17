# Processing 3 Sketches

Updated sketches for processing v3 from the follwoing repos :

- https://github.com/GlitchTools/ASDFPixelSort
( ASDFPixelSort )
- https://github.com/GlitchTools/Introwerks
( colorcrusher, diagonalGlitch, grid1_0*, introwaves, lineGlitch, randomBlocks, ruttetraEmulator, subtleSorting, vmap )
- https://github.com/bobvk/sketches
( auecho, crtdots, cubed, cubemap, dripdrip, echo, eyestrain2, kromachey, multicubes, mware, phaser, vhs, wahwah, yade, zigzag )

*grid1_0 has not been updated yet as the required lib "gifAnimation" is not updated for v3 yet.

Mostly just moving stuff from setup() that is now required to be in settings() (good naming scheme there, not confusing at all...)

According to the docs, "*The settings() method runs before the sketch has been set up, so other Processing functions cannot be used at that point. For instance, do not use loadImage() inside settings().*" - [source](https://processing.org/reference/settings_.html) and "*If you must change the size of your sketch, use surface.setSize(w, h) which is the one and only (safe) way to alter your sketch's size.*" - [source](https://github.com/processing/processing/wiki/Changes-in-3.0) ... But! Using loadImage() in settings() works (for now ?) while starting with a default sized window and then using surface.setSize() breaks a bunch of the effects, including my fav ruttetraEmulator (see ruttetraEmulator\broken-ruttetra.pde for a non-working example that follows the docs (as of 2015-02-17) as I understand them.