import numpy as np
import beat
import numpy.typing as npt
import matplotlib.pyplot as plt
from time import perf_counter

print("Running model")
    
def setup_initial_conditions() -> npt.NDArray:
    ic = {
        "V": -86.709,  # mV
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
        "Ca_i": 0.00013,  # millimolar
        "R_prime": 0.9068,
        "Ca_SR": 3.715,  # millimolar
        "Ca_ss": 0.00036,  # millimolar
        "Na_i": 10.355,  # millimolar
        "K_i": 138.3,  # millimolar
    }
    values = model.init_state_values(**ic)
    return values

import TP06_endo_cell as model

init_states = setup_initial_conditions()
parameters = model.init_parameter_values()
num_points = 1
num_states = len(init_states)
states = np.zeros((num_states, num_points))
states.T[:] = init_states
dt = 0.05
t_bound = 500.0
t0 = 0.0

V_index = model.state_indices("V")

nT = int((t_bound - t0) / dt) - 1
V = np.zeros((nT, num_points))
t0 = perf_counter()
# values = np.zeros_like(ic)
beat.odesolver.solve(
    fun=model.forward_generalized_rush_larsen,
    t_bound=t_bound,
    states=states,
    V=V,
    V_index=V_index,
    dt=dt,
    parameters=parameters,
    # extra={"g_s": g_s},
)
el = perf_counter() - t0
print(f"Elapsed time: {el} seconds")

fig, ax = plt.subplots()
for i in range(num_points):
    ax.plot(V[:, i])
fig.savefig("cell_endo.png")
