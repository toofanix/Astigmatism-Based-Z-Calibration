# Astigmatism-Based-Z-Calibration

Here are a series of scripts that I have developed that can be used to generate a Z calibration curve. This curve can then be used to estimate the Z position of a fluorophore based on its image. 

The method is based on astigmatism which introduces assymmetry in the point spread function(PSF) of the florescent image of the object above and below the focal point. Experimentally, this can be achieved by introducing a cylinderical lens(focal length ~1 m) infront of the camera.

In order to create the calibration curve, a wide-field image of fluorescent beads (bead size smaller than diffraction limit, in the example data I have used 20 nm beads) is collected over a z range of -1000 nm to +1000 nm ( step-size = 2 nm). Typically, 0 is the focal point.

Please follow the Wiki for more information about the scripts.

