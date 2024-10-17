## Description

Here, the needed files for the numerical bifurcation analysis of the modified models are provided. We first comment on the endocardial case. Notice that running these files will cause - depending on the used resources - same days. Moreover, the output folders have 500 - 800 MB and thus, they can not be uploaded here.

**List of Matlab function files and description**
- `TP06_endo.m`: the TP06 .m function file containing the 19-dimensional ODE model for the endocardial cell stated by ten Tusscher and Panfilov in 2006
- `TP06_endo_18d.m`: reduced TP06 model with fixed $[K]_i$ extracellular potassium ion concentration
- `TP06_endo_16d.m`: further reduced model with fixed gating variables $h$ and $j$ of the sodium current to their steady states (which are equal)
- `TP06_endo_14d.m`: further reduced model with additionaly fixed gating variables $x_{r_2}$ and $r$ of the rapid delayed rectifier current and the transient outward current, respectively
  
*needed funcation files for the bifurcation analysis including several derivates of the right hand side of the ODE*
- `TP06_endo_14d_bif.m` 
- `TP06_endo_16d_bif.m`
- `TP06_endo_18d_bif.m`
- `TP06_14D_bifurcation_endo.m`: main file to run the bifurcation analysis for the 14-dimensional model (MatCont7p5 is required)
- `TP06_16D_bifurcation_endo.m`: main file to run the bifurcation analysis for the 16-dimensional model (MatCont7p5 is required)

*visualisation of the derived data*
- `cpl_stability_codim1.m`: uses the data derived by MatCont to plot the equilibrium curve including important bifurcation points
- `plotlimitcycle.m`: uses the data derived by MatCont to plot the limit cycle curve
- `bif_plot_comparison_16d_14d.m`: compares the bifurcation diagram of the 14- and 16-dimensional model

<p align="center">
<img src="https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/blob/main/media/bif_plot_14d.png" width="33%"/><img src="https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/blob/main/media/bif_plot_16d.png" width="33%"/><img src="https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/blob/main/media/bif_plot_18d.png" width="33%"/>
  
  -From left to right: Bifurcation diagramm of the 14-dimensional, 16-dimensional and 18-dimensional modified TP06 endocardial model as stated the our manuscript-
</p>
