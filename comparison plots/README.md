## Description 

In this folder the provide the Matlab files for the TP06 model `fun_TP06_model.m` and its modified versions (14-dimensional `fun_mofidifed_TP06_epi_M_endo_14d.m`, 16-dimensional `fun_mofidifed_TP06_epi_M_endo_16d.m` and 18-dimensional `fun_mofidifed_TP06_epi_M_endo_18d.m`). In addition, a main file `simulation_mofidifed_TP06_epi_M_endo.m` is provided, which one has to run to produce the two following comparing plots:

<p align="center">
<img src="./media/comparison_epi_endo.png" width="75%"/>
<img src="./media/comparison_M.png" width="75%"/>
</p>

These plots are also the one included in our manuscript.

To see the differences in the function files one may run `visdiff`, e.g. `visdiff('fun_TP06_model.m','fun_mofidifed_TP06_epi_M_endo_14d.m')` in Matlab.
