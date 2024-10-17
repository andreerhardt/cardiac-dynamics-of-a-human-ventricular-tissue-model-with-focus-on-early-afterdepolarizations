## Description

**List of Matlab function files and description**
- `TP06_endo.m`: the TP06 .m function file containing the 19-dimensional ODE model for the endocardial cell stated by ten Tusscher and Panfilov in 2006
- `TP06_endo_18d.m`: reduced TP06 model with fixed $[K]_i$ extracellular potassium ion concentration
- `TP06_endo_16d.m`: further reduced model with fixed gating variables $h$ and $j$ of the sodium current to their stady states (which are equal)
- `TP06_endo_14d.m`: further reduced model with additionaly fixed gating variables $xr_2$ and $r$ of the rapid delayed rectifier current and the transient outward current, respectively
*needed funcation files for the bifurcation analysis including several derivates of the right hand side of the ODE*
- `TP06_endo_14d_bif.m`: 
- `TP06_endo_16d_bif.m`:
- `TP06_endo_18d_bif.m`:

<p align="center">
<img src="https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/blob/main/media/bif_plot_14d.png" width="33%"/><img src="https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/blob/main/media/bif_plot_16d.png" width="33%"/><img src="https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/blob/main/media/bif_plot_18d.png" width="33%"/>
</p>
