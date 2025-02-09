# Cardiac dynamics of the TP06 model with focus on early afterdepolarizations (EADs)

## Description

We modified and simplified the cardiac muscle cell model by ten Tusscher and Panfilov from 2006 (TP06 model) to perform numerical bifurcation analysis. This allows us to analyse the dynamics of the TP06 model and to predict the occurrence of normal action potentials or cardiac arrhythmia such as EADs.

The TP06 model  is stated in the following papers:
* _A model for human ventricular tissue_, **K. H. W. J. ten Tusscher, D. Noble, P. J. Noble, and A. V. Panfilov** (2004) https://doi.org/10.1152/ajpheart.00794.2003
* _Alternans and spiral breakup in a human ventricular tissue model_, **K. H. W. J. ten Tusscher, and A. V. Panfilov** (2006) https://doi.org/10.1152/ajpheart.00109.2006

In this repository we collect the MATLAB and Python files, which are needed to:
1) simulation and compare the TP06 model with our modified versions,
2) to analysis the modified TP06 model by means of (numerical) bifurcation theory using [MatCont7p5](https://sourceforge.net/projects/matcont/files/MatCont/MatCont7p5/),
3) to perform 2D simulations of the corresponding monodomain model using [FEniCS](https://fenicsproject.org) and [fenics-beat](https://github.com/finsberg/fenics-beat), see also the [documentation](https://finsberg.github.io/fenics-beat/README.html).

## Folders 
- [`./bifurcation analysis`](https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/tree/main/bifurcation%20analysis) here the needed MATLAB files are provided to run bifurcation analysis using [MatCont7p5](
https://sourceforge.net/projects/matcont/files/MatCont/MatCont7p5/).
- [`./comparison plots`](https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/tree/main/comparison%20plots) here the different functions files for the TP06 model and its reduced versions are provided as well as a main file to simulate the models using MATLAB and to create comparison plots.
- [`./cell simulations using cbcbeat`](https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/tree/main/cell%20simulations%20using%20cbcbeat) here, we use the ODE solver included in [cbcbeat](https://github.com/ComputationalPhysiology/cbcbeat) to compare the solutions of the full epi-, mid-myo- and endocardial TP06 model with its reduced version (14 dimensional).
- [`./cell simulations using fenics-beat`](https://github.com/andreerhardt/cardiac-dynamics-of-a-human-ventricular-tissue-model-with-focus-on-early-afterdepolarizations/tree/main/cell%20simulation%20using%20fencis-beat) here, we use the ODE solver included in [fenics-beat](https://github.com/finsberg/fenics-beat) to compare the solutions of the full epi-, mid-myo- and endocardial TP06 model with its reduced version (14 dimensional).
- [`./postprocessing and test`](https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/tree/main/postprocessing%20and%20test) here, we provide several files for postprocessing the data derived by MatCont to create different detailed bifurcation diagrams and a description how to use them.
- [`./1D monodomain simulation`](https://github.com/andreerhardt/cardiac-dynamics-of-a-human-ventricular-tissue-model-with-focus-on-early-afterdepolarizations/tree/main/1D%20monodomain%20simulation) here, we provide the MATLAB code to run our 1D monodomain experiments.
- [`./monodomain simulations using cbcbeat`](https://github.com/andreerhardt/cardiac-dynamics-of-a-human-ventricular-tissue-model-with-focus-on-early-afterdepolarizations/tree/main/monodomain%20simulations%20using%20cbcbeat) here, we provide the python files to run 2D monodomain simualtions using [cbcbeat](https://github.com/ComputationalPhysiology/cbcbeat).
- [`./monodomain simulations using FEniCS-beat`](https://github.com/andreerhardt/cardiac-dynamics-of-a-human-ventricular-tissue-model-with-focus-on-early-afterdepolarizations/tree/main/monodomain%20simulations%20using%20FEniCS-beat) here, we provide the python files to run 2D monodomain simualtions using [fenics-beat](https://github.com/finsberg/fenics-beat).

## Background

To be able to analysis the dynamics of a cardiac muscle cell mathematically one describes the biological cell 

<p align="center">
<img src="https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/blob/main/media/biological_cell.png" width="50%"/>
</p>

as physical system

<p align="center">
<img src="https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/blob/main/media/physical_system.png" width="50%"/>
</p>

which one can utilize to derive a mathematical model of a cardiac muscle cell. This approach goes back to Hodgkin and Huxley in 1952 [_(A quantitative description of membrane current and its application to conduction and excitation in nerve)_](https://doi.org/10.1113/jphysiol.1952.sp004764). The electrophysiological behavior of a cardiac myocyte is represented by the following ODE:

$$
	C_m\frac{d V}{dt}=-I_\text{ion}+I_\text{stim},
$$

where $V$ denotes the voltage (in $mV$) and $t$ the time (in $ms$), while $I_\mathrm{ion}$ is the sum of all transmembrane ionic currents, i.e.

$$
I_\text{ion}=I_\text{K1}+I_\text{to}+I_\text{Kr}+I_\text{Ks}+I_\text{CaL}+I_\text{NaK}+I_\text{Na}
+I_\text{bNa}+I_\text{NaCa}+I_\text{bCa}+I_\text{pK}+I_\text{pCa}.
$$

These currents are depending on individual ionic conductances $G_\text{current}$ and Nernst potentials $E_\text{current}$. Moreover, they may depend on gating variables, which are important for the activation and inactivation of the ion currents. Using such a model one is able to simulation characteristic action potential of a cardiac muscle cell

<p align="center">
<img src="https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/blob/main/media/AP.png" width="50%"/>
</p>

as well as EADs

<p align="center">
<img src="https://github.com/andreerhardt/cardiac-dynamics-of-the-TP06-model-with-focus-on-EADs/blob/main/media/EAD.png" width="50%"/>
</p>

**Bifurcation theory:** Bifurcation analysis of such kind of model is performed in several studies, see for instance: 
* _Bifurcation Analysis of a Modified Cardiac Cell Model_, **André H. Erhardt, and Susanne Solem** (2022) https://doi.org/10.1137/21M1425359
* _Modifications of sodium channel voltage dependence induce arrhythmia-favouring dynamics of cardiac action potentials_, **Pia Rose, Jan-Hendrik Schleimer, Susanne Schreiber** (2020) https://doi.org/10.1371/journal.pone.0236949
* _On complex dynamics in a Purkinje and a ventricular cardiac cell model_, **André H. Erhardt, and Susanne Solem** (2021) https://doi.org/10.1016/j.cnsns.2020.105511

Here, the main focus of this study is on the model reduction and enhancement of the efficiency of the numerical bifurcation analysis without loss of information to the original TP06 model.
