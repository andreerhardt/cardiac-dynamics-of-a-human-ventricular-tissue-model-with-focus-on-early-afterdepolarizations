## Description 

In this folder we provide the MATLAB files for the TP06 model `fun_TP06_model.m` and its modified versions as
- 14-dimensional `fun_mofidifed_TP06_epi_M_endo_14d.m`,
- 16-dimensional `fun_mofidifed_TP06_epi_M_endo_16d.m`,
- 18-dimensional `fun_mofidifed_TP06_epi_M_endo_18d.m`

model. In addition, a main file `simulation_mofidifed_TP06_epi_M_endo.m` is provided, which one may run to produce the two following comparison plots:

<p align="center">
<img src="https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/blob/main/media/comparison_epi_endo.png" width="75%"/>
<img src="https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/blob/main/media/comparison_M.png" width="75%"/>
</p>

These plots are also the ones included in our manuscript.

To see the differences in the function files one may run `visdiff`, e.g. `visdiff('fun_TP06_model.m','fun_mofidifed_TP06_epi_M_endo_14d.m')` in Matlab.

Finally, we provide a second main file `simulation_mofidifed_TP06_epi_M_endo_2.m` to produce Figure 6 of our manusript yielding

<p align="center">
<img src="https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/blob/main/media/comparison_epi_endo_1.png" width="75%"/>
<img src="https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/blob/main/media/comparison_M_1.png" width="75%"/>
</p>
