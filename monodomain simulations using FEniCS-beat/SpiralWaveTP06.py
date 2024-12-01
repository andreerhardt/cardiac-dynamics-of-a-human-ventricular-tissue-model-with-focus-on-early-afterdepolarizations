#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 20 20:09:29 2024

@author: André H. Erhardt (andre.erhardt@wias-berlin.de, https://orcid.org/0000-0003-4389-8554)
"""

from pathlib import Path
import dolfin
import matplotlib.pyplot as plt
import numpy as np
import numpy.typing as npt
import gotranx
import beat

ex_TP06 = 0

def setup_initial_conditions() -> npt.NDArray:
    ic = {
        "V": -86.709,      # mV
        "Xr1": 0.00448,
        "Xr2": 0.476,
        "Xs": 0.0087,
        "m": 0.00155,
        "h": 0.7573,
        "j": 0.7,
        "d": 3.164e-5,
        "f": 0.8009,
        "f2": 0.9778,
        "fCass": 0.9953,
        "s": 0.3212,
        "r": 2.235e-8,
        "Ca_i": 0.00013,    # millimolar
        "R_prime": 0.9068,
        "Ca_SR": 3.715,     # millimolar
        "Ca_ss": 0.00036,   # millimolar
        "Na_i": 10.355,     # millimolar
        "K_i": 138.3        # millimolar
    }
    values = model.init_state_values(**ic)
    return values

save_every_ms = 1.0
transverse    = True#False
end_time      = 10000
mesh_unit     = "mm"
dx            = 0.25 * beat.units.ureg("mm").to(mesh_unit).magnitude
L             = 100.0 * beat.units.ureg("mm").to(mesh_unit).magnitude
data          = beat.geometry.get_2D_slab_geometry(Lx=L,Ly=L,dx=dx,transverse=transverse)

V = dolfin.FunctionSpace(data.mesh, "CG", 1)

model_path = Path("tentusscher_panfilov_2006_epi_cell.py")
if not model_path.is_file():
    here = Path.cwd()
    ode = gotranx.load_ode(
        here
        / "tentusscher_panfilov_2006"
        / "tentusscher_panfilov_2006_epi_cell.ode"
    )
    code = gotranx.cli.gotran2py.get_code(
        ode, scheme=[gotranx.schemes.Scheme.forward_generalized_rush_larsen]
    )
    model_path.write_text(code)

import tentusscher_panfilov_2006_epi_cell

model = tentusscher_panfilov_2006_epi_cell.__dict__

C_m        = 1.0 * beat.units.ureg("uF/cm**2")
chi        = 1.0 * beat.units.ureg("cm**-1")
fun        = model["forward_generalized_rush_larsen"]
y          = model["init_state_values"]()
time       = dolfin.Constant(0.0)

if ex_TP06 == True:
    duration   = 1.5
    dt         = 0.05
    s2_start   = 340
    parameters = model["init_parameter_values"](stim_amplitude=0.0)
    output_folder = "./output_heart_2D_TP06_AP/"
else:
    duration   = 1.5
    dt         = 0.02
    s2_start   = 340
    parameters = model["init_parameter_values"](stim_amplitude=0.0,g_CaL = 5*0.0398,g_Kr = 0.18*0.153,g_Ks = 0.098)
    output_folder = "./output_heart_2D_TP06_EAD/"
    
save_freq     = round(save_every_ms / dt)

expr_single_s1s2 = dolfin.Expression("(t < duration && x[0] < 0.1*L)?52.0:((t > delay && t < delay+duration) && (x[1] < L/2))?52.0:0.0",
                                         t=time,
                                         L=L,
                                         delay=s2_start,
                                         duration=duration,
                                         degree=0)

I_s_s1s2 = beat.base_model.Stimulus(dz=dolfin.dx, expr=expr_single_s1s2)

V_ode = dolfin.FunctionSpace(data.mesh, "Lagrange", 1)

pde      = beat.MonodomainModel(time=time, mesh=data.mesh, M=0.154, I_s=I_s_s1s2, C_m=C_m.magnitude)
ode      = beat.odesolver.DolfinODESolver(v_ode=dolfin.Function(V_ode),
                                          v_pde=pde.state,
                                          fun=fun,
                                          init_states=y,
                                          parameters=parameters,
                                          num_states=len(y),
                                          v_index=model["state_index"]("V"))
solver    = beat.MonodomainSplittingSolver(pde=pde, ode=ode)

file_v    = dolfin.File(output_folder + "voltage_TP06.pvd")

t         = 0.0
save_freq = int(1.0 / dt)
i         = 0

while t < end_time + 1e-12:
    if i % save_freq == 0:
        print(f"time = {t}")
        if round(t,2) in range(0,end_time+1,10):
            Vv     = dolfin.FunctionSpace(data.mesh, "CG", 1)
            outv   = dolfin.project(pde.state,Vv)
            outv.rename("voltage_TP06","voltage_TP06")
            file_v << (outv,t)

    solver.step((t, t + dt))
    i += 1
    t += dt
