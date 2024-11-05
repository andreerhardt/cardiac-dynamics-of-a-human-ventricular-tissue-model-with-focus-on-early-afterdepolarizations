import math
import pylab
from cbcbeat import *

# Disable adjointing
import cbcbeat
if cbcbeat.dolfin_adjoint:
    parameters["adjoint"]["stop_annotating"] = True

# For easier visualization of the variables
parameters["reorder_dofs_serial"] = False

# For computing faster
parameters["form_compiler"]["representation"] = "uflacs"
parameters["form_compiler"]["cpp_optimize"] = True
flags = "-O3 -ffast-math -march=native"
parameters["form_compiler"]["cpp_optimize_flags"] = flags

from tentusscher_panfilov_2006_endo_cell import Tentusscher_panfilov_2006_endo
from tentusscher_panfilov_2006_epi_cell import Tentusscher_panfilov_2006_epi
from tentusscher_panfilov_2006_endo_cell_14d import Tentusscher_panfilov_2006_endo_14d
from tentusscher_panfilov_2006_epi_cell_14d import Tentusscher_panfilov_2006_epi_14d


class Stimulus(UserExpression):
    "Some self-defined stimulus."
    def __init__(self, time, amp, **kwargs):
        self.t   = time
        self.amp = amp
        super().__init__(**kwargs)
    def eval(self, value, x):
        if float(self.t) >= 0 and float(self.t) <= 2:
            value[0] = self.amp
        else:
            value[0] = 0.0
    def value_shape(self):
        return ()

def plot_results(times, values, show=True):
    "Plot the evolution of each variable versus time."

    variables = list(zip(*values))
    pylab.figure(figsize=(20, 10))

    rows = int(math.ceil(math.sqrt(len(variables))))
    for (i, var) in enumerate([variables[0],]):
        pylab.plot(times, var, '*-')
        pylab.xlabel("t (ms)")
        pylab.ylabel("V (mV)")
        pylab.grid(True)

    info_green("Saving plot to 'comparison.pdf'")
    pylab.savefig("comparison.pdf")
    if show:
        pylab.show()

def main(scenario="TP06 endocardial model"):
    "Solve a single cell model on some time frame."
    # Initialize model and assign stimulus
    if scenario == "TP06 endocardial model":
        params = Tentusscher_panfilov_2006_endo.default_parameters()
        new = {"g_CaL": params["g_CaL"]*5,
               "g_Kr": params["g_Kr"]*0.18}
        model = Tentusscher_panfilov_2006_epi(params=new)
        amp   = 52
    elif scenario == "TP06 epicardial model":
        params = Tentusscher_panfilov_2006_epi.default_parameters()
        new = {"g_CaL": params["g_CaL"]*5,
               "g_Kr": params["g_Kr"]*0.18}
        model = Tentusscher_panfilov_2006_epi(params=new)
        amp   = 52
    elif scenario == "TP06 mid-myocardial model":
        params = Tentusscher_panfilov_2006_epi.default_parameters()
        new = {"g_CaL": params["g_CaL"]*5,
               "g_Kr": params["g_Kr"]*0.18,
               "g_Ks": 0.098}
        model = Tentusscher_panfilov_2006_epi(params=new)
        amp   = 52
    elif scenario == "TP06 endocardial model (14d)":
        params = Tentusscher_panfilov_2006_endo_14d.default_parameters()
        new = {"g_CaL": params["g_CaL"]*5,
               "g_Kr": params["g_Kr"]*0.18}
        model = Tentusscher_panfilov_2006_epi_14d(params=new)
        amp   = 95
    elif scenario == "TP06 epicardial model (14d)":
        params = Tentusscher_panfilov_2006_epi_14d.default_parameters()
        new = {"g_CaL": params["g_CaL"]*5,
               "g_Kr": params["g_Kr"]*0.18}
        model = Tentusscher_panfilov_2006_epi_14d(params=new)
        amp   = 95
    elif scenario == "TP06 mid-myocardial model (14d)":
        params = Tentusscher_panfilov_2006_epi_14d.default_parameters()
        new = {"g_CaL": params["g_CaL"]*5,
               "g_Kr": params["g_Kr"]*0.18,
               "g_Ks": 0.098}
        model = Tentusscher_panfilov_2006_epi_14d(params=new)
        amp   = 95
        
    print(new)
        
    time = Constant(0.0)
    model.stimulus = Stimulus(time=time, amp = amp, degree=0)

    # Initialize solver
    params = SingleCellSolver.default_parameters()
    params["scheme"] = "GRL1"
    solver = SingleCellSolver(model, time, params)

    # Assign initial conditions
    (vs_, vs) = solver.solution_fields()
    vs_.assign(model.initial_conditions())

    # Solve and extract values
    dt = 0.001
    interval = (0.0, 2000.0)

    solutions = solver.solve(interval, dt)
    times = []
    values = []
    for ((t0, t1), vs) in solutions:
        print(("Current time: %g" % t1))
        times.append(t1)
        values.append(vs.vector().get_local())

    return times, values

def compare_results(times, many_values, legends=(), show=True):
    "Plot the evolution of each variable versus time."

    pylab.figure(figsize=(20, 10))
    for values in many_values:
        variables = list(zip(*values))
        rows = int(math.ceil(math.sqrt(len(variables))))
        for (i, var) in enumerate([variables[0],]):
            pylab.plot(times, var, '-')
            pylab.xlabel("t (ms)")
            pylab.ylabel("V (mV)")
            pylab.grid(True)

    pylab.legend(legends)
    info_green("Saving plot to 'comparison.pdf'")
    pylab.savefig("comparison.pdf")
    if show:
        pylab.show()

if __name__ == "__main__":

    (times, values1) = main("TP06 endocardial model")
    (times, values2) = main("TP06 epicardial model")
    (times, values3) = main("TP06 mid-myocardial model")
    (times, values4) = main("TP06 endocardial model (14d)")
    (times, values5) = main("TP06 epicardial model (14d)")
    (times, values6) = main("TP06 mid-myocardial model (14d)")
    #compare_results(times, [values1, values2, values3],
    #                legends=("TP06 endocardial model", "TP06 epicardial model","TP06 mid-myocardial model"),
    #                show=True)
    compare_results(times, [values1, values2, values3, values4, values5, values6],
                    legends=("TP06 endocardial model", "TP06 epicardial model","TP06 mid-myocardial model","TP06 endocardial model (14d)","TP06 epicardial model (14d)","TP06 mid-myocardial model (14d)"),
                    show=True)
