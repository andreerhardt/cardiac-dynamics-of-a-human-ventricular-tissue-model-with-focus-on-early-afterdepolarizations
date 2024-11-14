# Description

This folder contains several postprocessing files to produce bifurcation diagrams based on the output data of MatCont. 

## List of files
- `cpl_stability_codim1.m`

This file creates a 3D equilibrium curve, determines the stability of the curve and the bifurcation points (if existent), i.e. Andronov-Hopf bifurcation, fold bifurcation and branch point bifurcation by calling *cpl_stability_codim1(xeq,seq,feq,variable1,variable2,color,Pointsize,Linesize)*. 

Here, *xeq,seq,feq* are the data comupted by Matcont, *variable1,variable2* are the variables of the ODE system which have to be chosen and finally, *color,Pointsize,Linesize* need to be chosen according to personal preferences.
- `plotlimitcycle.m` 

This file creates a 3D limit cycle plot by calling *plotlimitcycle(xlc,vlc,slc,e,color,EdgeAlpha,LineStyle,FaceAlpha)*.

Here, `xlc,vlc,slc` are the data computed by MatCont during certain limit cycle continuations, i.e. from an Andronov-Hopf bifurcation, a Period-Doubling bifurcation or a limit cycle itself. `e` is the 3 dimensional vector *[size(xlc,1) variable1 variable2]*, where the *variable1,variable2* are the same as in `cpl_stability_codim1.m`. Moreover, *color,EdgeAlpha,LineStyle,FaceAlpha* need to be chosen according to personal preferences.

- `plot_bif_diagram.m`

This file creates a "full" bifurcation diagram, including the equilibrium curve, its stability, if existing Andronov-Hopf bifurcations, fold bifurcations and branch point bifurcations, and also a the first limit cycle branch including torus bifurcations and Period-Doubling bifurcations if existent. Here, one has to call *plot_bif_diagram(xeq,seq,feq,xlc,slc,flc,variable1,variable2,color,Pointsize,Linesize,e,EdgeAlpha,LineStyle,FaceAlpha)*.

- `test_bif_epi_14d.m`

This file contains a small continuation example determinen two supercritical Andronov-Hopf bifurcations and the corresponding equilibrium curve, the first limit cycle branch containing a torus and a Period-Doubling bifurcation (only 200 steps) and a second limit cycle branch (only 150 steps). Running this file takes only some minutes and produces a data set less than 23 MB.

- `plot_test.m`

After creating the data while running `test_bif_epi_14d.m`, the file `plot_test.m` shows several plots using `cpl_stability_codim1.m`, `plotlimitcycle.m` , `plot_bif_diagram.m` and certain combinations to create different detailed bifurcation diagrams and to explain the usage of this files.

