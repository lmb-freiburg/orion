# ORION
Here you can find the code for the BMVC 2017 version of "Orientation-boosted Voxel Nets for 3D Object Recognition", a.k.a ORION.

![teaser](https://lmb.informatik.uni-freiburg.de/Publications/2017/SZB17a/teaser_w.png)

If you use this code for research please cite:
   
    @InProceedings{SZB17a,
      author       = "N. Sedaghat and M. Zolfaghari and E. Amiri and T. Brox",
      title        = "Orientation-boosted voxel nets for 3D object recognition",
      booktitle    = "British Machine Vision Conference (BMVC)",
      month        = " ",
      year         = "2017",
      url          = "http://lmb.informatik.uni-freiburg.de/Publications/2017/SZB17a"
    }


Caffe Installation
------------------

Please download, build and install the version of caffe introduced [here](https://lmb.informatik.uni-freiburg.de/resources/opensource/unet.en.html) -- we use it for the provided 3D augmentation capabilities.

Modelnet40 Aligned Objects
---------------------------
Modelnet40 aligned objects can be downloaded from the links below.
If you use this modified dataset, please also cite the following work from which we borrowed techniques for the auto-alignment:

    @InProceedings{SB15,
      author       = "N. Sedaghat and T. Brox",
      title        = "Unsupervised Generation of a Viewpoint Annotated Car Dataset from Videos",
      booktitle    = "IEEE International Conference on Computer Vision (ICCV)",
      year         = "2015",
      url          = "http://lmb.informatik.uni-freiburg.de/Publications/2015/SB15"
      }
      

[Manually-aligned Modelnet40](https://lmb.informatik.uni-freiburg.de/resources/datasets/ORION/modelnet40_manually_aligned.tar)

[Auto-aligned Modelnet40](https://lmb.informatik.uni-freiburg.de/resources/datasets/ORION/modelnet40_auto_aligned.tar)

Auto-alignment code will be published soon. 
