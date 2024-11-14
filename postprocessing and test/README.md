# Description

This folder contains several postprocessing files to produce bifurcation diagrams based on the output data of MatCont. 

**List of files**
- `cpl_stability_codim1.m`

This file creates the 3D equilibrium curve, where two variables have to be chosen, determines the stability of the curve and the bifurcation points (if existent), i.e. Andronov-Hopf Bifurcation, fold bifurcation and branch point bifurcation by calling *cpl_stability_codim1(xeq,seq,feq,variable1,variable2,color,Pointsize,Linesize)*. Here, *xeq,seq,feq* are the data comupted via Matcont, *variable1,variable2* are the variables of the ODE system which have to be chosen and finally, *color,Pointsize,Linesize* need be chosen according to personal preferences.
- `plotlimitcycle.m` ***plotlimitcycle(x,v,s,e,color,EdgeAlpha,LineStyle,FaceAlpha)***

