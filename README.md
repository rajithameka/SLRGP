# SLRGP
SLRGP - Sequential Laplacian Regularized Gaussian Process

SLRGP algorithm uses Laplacian regularized active learning measure (LR-AL) to select the next informative evaluation point to efficiently estimate the underlying black-box function. 

Implementation is provided in the folder named Code. To run the code, GPML (Gaussian Process for Machine Learning) should be installed. For more information on GPML, please visit http://www.gaussianprocess.org/gpml/code/matlab/doc/.

After installing GPML, run Main_Gif_SLRGP.m to generate the plots shown below:

![SLRGP](Code/Branin_True_Contour.png)

![SLRGP](Code/SLRGPBranintest.gif)
