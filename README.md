# Cardiac dynamics of the TP06 model with focus on early afterdepolarizations (EADs)

## Description

We modified and simplfied of the cardiac muscle cell model by Ten Tusscher and Panfilov from 2006 (TP06 model) to perform numerical bifurcation analysis. This allows us to analysis the dynamics of the TP06 model and to predict the occurence of normal action potentials or cardiac arrhythmia such as early afterdepolarizations.

The TP06 model  is stated in the following papers:
* _A model for human ventricular tissue_, **K. H. W. J. ten Tusscher, D. Noble, P. J. Noble, and A. V. Panfilov** (2004) https://doi.org/10.1152/ajpheart.00794.2003
* _Alternans and spiral breakup in a human ventricular tissue model_, **K. H. W. J. ten Tusscher, and A. V. Panfilov** (2006) https://doi.org/10.1152/ajpheart.00109.2006

In this repository we collect the MATLAB files, which are needed to:
1) simulation and compare the TP06 model with our modified version,
2) to analysis the modified TP06 model by means of (numerical) bifurcation theory using Matcont.

***Folders***
- [`./bifurcation analysis`](https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/tree/main/bifurcation%20analysis) here the needed Matlab files are provided to run bifurcation analysis using [MatCont7p5](
https://sourceforge.net/projects/matcont/files/MatCont/MatCont7p5/).
- [`./comparison plots`](https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/tree/main/comparison%20plots) here the different functions files for the TP06 model and its reduced versions are provided as well as a main file to simulate the models using Matlab and to create comparison plots.

## Background

Bifurcation analysis of such kind of model is performed in several studies, see for instance: 
* _Bifurcation Analysis of a Modified Cardiac Cell Model_, **André H. Erhardt, and Susanne Solem** (2022) https://doi.org/10.1137/21M1425359
* _Modifications of sodium channel voltage dependence induce arrhythmia-favouring dynamics of cardiac action potentials_, **Pia Rose, Jan-Hendrik Schleimer, Susanne Schreiber** (2020) https://doi.org/10.1371/journal.pone.0236949
* _On complex dynamics in a Purkinje and a ventricular cardiac cell model_, **André H. Erhardt, and Susanne Solem** (2021) https://doi.org/10.1016/j.cnsns.2020.105511

Here, the main focus in on the model reduction and enhancement of the efficiency of the numerical bifurcation analysis without loss of information to the original TP06 model.

<p align="center">
	[embed][http://example.com/file.pdf](https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/blob/main/media/biological_cell.pdf)[/embed]
<img src="https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/blob/main/media/biological_cell.pdf" width="50%"/><img src="https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/blob/main/media/physical_system.pdf" width="50%"/><img
  
  _From left to right: Bifurcation diagramm of the 14-dimensional, 16-dimensional and 18-dimensional modified TP06 endocardial model as stated the our manuscript_
</p>

The electrophysiological behaviour of a cardiac myocyte is represented by the following ODE:

$$
	C_m\frac{d V}{dt}=-I_\text{ion}+I_\text{stim},
$$

where $V$ denotes the voltage (in $mV$) and $t$ the time (in $ms$), while $I_\mathrm{ion}$ is the sum of all transmembrane ionic currents, i.e.

$$
I_\text{ion}=I_\text{K1}+I_\text{to}+I_\text{Kr}+I_\text{Ks}+I_\text{CaL}+I_\text{NaK}+I_\text{Na}
+I_\text{bNa}+I_\text{NaCa}+I_\text{bCa}+I_\text{pK}+I_\text{pCa}.
$$

These currents are depending on individual ionic conductances $G_\text{current}$ and Nernst potentials $E_\text{current}$. Moreover, they may depend on gating variables, which are important for the activation and inactivation of the ion currents.
