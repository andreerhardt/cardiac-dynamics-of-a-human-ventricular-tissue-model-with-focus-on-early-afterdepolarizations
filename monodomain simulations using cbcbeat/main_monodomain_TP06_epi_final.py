#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 06 22:09:29 2024

@author: André H. Erhardt (andre.erhardt@wias-berlin.de, https://orcid.org/0000-0003-4389-8554)
"""

from tentusscher_panfilov_2006_epi_cell import Tentusscher_panfilov_2006_epi_cell

import matplotlib.pyplot as plt
import math
import time
from cbcbeat import *

#case = 1 # normal AP
case = 2 # normal EAD mid-myocardial cell or epicardical cell with reduced Ks current after 500 ms

# Define the computational domain
L    = 100 # mm
mesh = RectangleMesh(Point(0,0),Point(L,L),400,400,'left/right') # Computational domain dx = 0.25 mm

# Time stepping parameters
time     = Constant(0.0)
T        = 10000.0
nsteps   = round(T)
interval = (0.0, T)

# Turn on FFC/FEniCS optimizations
flags = ["-O3", "-ffast-math", "-march=native"]
parameters["form_compiler"]["representation"]     = "uflacs"
parameters["form_compiler"]["cpp_optimize"]       = True
parameters["form_compiler"]["cpp_optimize_flags"] = " ".join(flags)
parameters["form_compiler"]["quadrature_degree"]  = 5

# Turn off adjoint functionality
import cbcbeat
if cbcbeat.dolfin_adjoint:
    parameters["adjoint"]["stop_annotating"] = True

# Define the conductivity (tensors)
M_i = 0.154
M_e = None

# Pick a cell model (see supported_cell_models for tested ones)
params   = Tentusscher_panfilov_2006_epi_cell.default_parameters()
parsnew  = {"g_CaL":      params["g_CaL"]*5,
            "g_Kr":       params["g_Kr"]*0.1,
            "g_Ks":       params["g_Ks"]}
parsnew2 = {"g_CaL":      params["g_CaL"]*5,
            "g_Kr":       params["g_Kr"]*0.18,
            "g_Ks":       0.98}

if case == 1:
    output_folder = "./output_heart_2D_AP/"
    cell_model    = Tentusscher_panfilov_2006_epi_cell()
    file          = File(output_folder + "voltage_TP06_AP.pvd")
    dt            = 0.05
    duration      = 1.5
    delay         = 340.0
elif case == 2:
    output_folder = "./output_heart_2D_EAD/"
    cell_model    = Tentusscher_panfilov_2006_epi_cell(params=parsnew2)
    file          = File(output_folder + "voltage_TP06_EAD.pvd")
    dt            = 0.02
    duration      = 1.5
    delay         = 340.0
    print(dt)

stimulus = Expression(
              "(t < duration && x[0] < 0.1*L)?52.0:((t > delay && t < delay+duration) && (x[1] < L/2 ))?52.0:0.0",
              t=time,
              L=L,
              delay=delay,
              duration=duration,
              degree=0)


# Collect this information into the CardiacModel class
cardiac_model = CardiacModel(mesh, time, M_i, M_e, cell_model, stimulus)

# Customize and create a splitting solver
ps = SplittingSolver.default_parameters()
ps["theta"] = 0.5                                               # Second order splitting scheme - Time stepping parameter (Crank-Nicolson)
ps["pde_solver"] = "monodomain"                                 # Use Monodomain model for the PDEs
ps["CardiacODESolver"]["scheme"] = "RL1"                       # 1st order Rush-Larsen for the ODEs GRL1, RL1
ps["MonodomainSolver"]["linear_solver_type"] = "iterative"
ps["MonodomainSolver"]["algorithm"] = "cg"
ps["MonodomainSolver"]["preconditioner"] = "petsc_amg"
ps["MonodomainSolver"]["default_timestep"] = dt

solver = SplittingSolver(cardiac_model, params=ps)

# Extract the solution fields and set the initial conditions
(vs_, vs, vur) = solver.solution_fields()
vs_.assign(cell_model.initial_conditions())

timer    = Timer("XXX Forward solve") # Time the total solve

# Solve!
for (timestep, fields) in solver.solve(interval, dt):
    print("(t_0, t_1) = (%g, %g)", timestep)
    
    # Extract the components of the field (vs_ at previous timestep,
    # current vs, current vur)
    (vs_, vs, vur) = fields
    if timestep[0] == 0:
        V = project(vs.sub(0),FunctionSpace(mesh,'CG',1))
        V.rename('V','Voltage')
        file << (V, 0)
    
    if round(timestep[1],3) in range(0,nsteps+1,10):
        V = project(vs.sub(0),FunctionSpace(mesh,'CG',1))
        V.rename('V','Voltage')
        file << (V, timestep[1]) 
        

timer.stop()

# Visualize some results
surf = plot(vs[0], title="Transmembrane potential V (mV) at end time", cmap='viridis')
cbar = plt.colorbar(surf)
ax = plt.gca()
ax.set_axis_off()
plt.savefig("TransmembranePot.pdf")
# List times spent
list_timings(TimingClear.keep, [TimingType.user])

print("Success!")
