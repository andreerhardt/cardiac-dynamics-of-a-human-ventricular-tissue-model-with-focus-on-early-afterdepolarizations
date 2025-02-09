from __future__ import division
from collections import OrderedDict
import ufl

from cbcbeat.dolfinimport import *
from cbcbeat.cellmodels import CardiacCellModel

class Tentusscher_panfilov_2006_epi(CardiacCellModel):
    def __init__(self, params=None, init_conditions=None):
        """
        Create cardiac cell model

        *Arguments*
         params (dict, :py:class:`dolfin.Mesh`, optional)
           optional model parameters
         init_conditions (dict, :py:class:`dolfin.Mesh`, optional)
           optional initial conditions
        """
        CardiacCellModel.__init__(self, params, init_conditions)

    @staticmethod
    def default_parameters():
        "Set-up and return default parameters."
        params = OrderedDict([("P_kna", 0.03),
                              ("g_K1", 5.405),
                              ("g_Kr", 0.153),
                              ("g_Ks", 0.392),
                              ("g_Na", 14.838),
                              ("g_bna", 0.00029),
                              ("g_CaL", 3.98e-5),
                              ("g_bca", 0.000592),
                              ("g_to", 0.294),
                              ("K_mNa", 40),
                              ("K_mk", 1),
                              ("P_NaK", 2.724),
                              ("K_NaCa", 1000),
                              ("K_sat", 0.1),
                              ("Km_Ca", 1.38),
                              ("Km_Nai", 87.5),
                              ("alpha", 2.5),
                              ("gamma", 0.35),
                              ("K_pCa", 0.0005),
                              ("g_pCa", 0.1238),
                              ("g_pK", 0.0146),
                              ("Buf_c", 0.2),
                              ("Buf_sr", 10),
                              ("Buf_ss", 0.4),
                              ("Ca_o", 2),
                              ("EC", 1.5),
                              ("K_buf_c", 0.001),
                              ("K_buf_sr", 0.3),
                              ("K_buf_ss", 0.00025),
                              ("K_up", 0.00025),
                              ("V_leak", 0.00036),
                              ("V_rel", 0.102),
                              ("V_sr", 0.001094),
                              ("V_ss", 5.468e-05),
                              ("V_xfer", 0.0038),
                              ("Vmax_up", 0.006375),
                              ("k1_prime", 0.15),
                              ("k2_prime", 0.045),
                              ("k3", 0.06),
                              ("k4", 0.005),
                              ("max_sr", 2.5),
                              ("min_sr", 1),
                              ("Na_o", 140),
                              ("Cm", 1),
                              ("F", 96485.3415),
                              ("R", 8314.472),
                              ("T", 310),
                              ("V_c", 0.016404),
                              ("stim_amplitude", 52),
                              ("stim_duration", 2),
                              ("stim_period", 1000),
                              ("stim_start", 0),
                              ("K_o", 5.4)])
        return params

    @staticmethod
    def default_initial_conditions():
        "Set-up and return default initial conditions."
        ic = OrderedDict([("V", -86.709),
                          ("Xr1", 0.00448),
                          ("Xr2", 0.476),
                          ("Xs", 0.0087),
                          ("m", 0.00155),
                          ("h", 0.7573),
                          ("j", 0.7225),
                          ("d", 3.164e-5),
                          ("f", 0.8009),
                          ("f2", 0.9778),
                          ("fCass", 0.9953),
                          ("s", 0.3212),
                          ("r", 2.235e-8),
                          ("Ca_i", 0.00013),
                          ("R_prime", 0.9068),
                          ("Ca_SR", 3.715),
                          ("Ca_ss", 0.00036),
                          ("Na_i", 10.355),
                          ("K_i", 138.3)]) 
        return ic

    def _I(self, v, s, time):
        """
        Original gotran transmembrane current dV/dt
        """
        time = time if time else Constant(0.0)

        # Assign states
        V = v
        assert(len(s) == 18)
        Xr1, Xr2, Xs, m, h, j, d, f, f2, fCass, s, r, Ca_i, R_prime, Ca_SR,\
            Ca_ss, Na_i, K_i = s

        # Assign parameters
        P_kna = self._parameters["P_kna"]
        g_K1 = self._parameters["g_K1"]
        g_Kr = self._parameters["g_Kr"]
        g_Ks = self._parameters["g_Ks"]
        g_Na = self._parameters["g_Na"]
        g_bna = self._parameters["g_bna"]
        g_CaL = self._parameters["g_CaL"]
        g_bca = self._parameters["g_bca"]
        g_to = self._parameters["g_to"]
        K_mNa = self._parameters["K_mNa"]
        K_mk = self._parameters["K_mk"]
        P_NaK = self._parameters["P_NaK"]
        K_NaCa = self._parameters["K_NaCa"]
        K_sat = self._parameters["K_sat"]
        Km_Ca = self._parameters["Km_Ca"]
        Km_Nai = self._parameters["Km_Nai"]
        alpha = self._parameters["alpha"]
        gamma = self._parameters["gamma"]
        K_pCa = self._parameters["K_pCa"]
        g_pCa = self._parameters["g_pCa"]
        g_pK = self._parameters["g_pK"]
        Ca_o = self._parameters["Ca_o"]
        Na_o = self._parameters["Na_o"]
        F = self._parameters["F"]
        R = self._parameters["R"]
        T = self._parameters["T"]
        K_o = self._parameters["K_o"]

        # Init return args
        current = [ufl.zero()]*1

        # Expressions for the Reversal potentials component
        E_Na = R*T*ufl.ln(Na_o/Na_i)/F
        E_K = R*T*ufl.ln(K_o/K_i)/F
        E_Ks = R*T*ufl.ln((Na_o*P_kna + K_o)/(K_i + P_kna*Na_i))/F
        E_Ca = 0.5*R*T*ufl.ln(Ca_o/Ca_i)/F

        # Expressions for the Inward rectifier potassium current component
        alpha_K1 = 0.1/(1 + 6.14421235333e-06*ufl.exp(-0.06*E_K + 0.06*V))
        beta_K1 = (3.06060402008*ufl.exp(-0.0002*E_K + 0.0002*V) +\
            0.367879441171*ufl.exp(-0.1*E_K + 0.1*V))/(1 + ufl.exp(-0.5*V +\
            0.5*E_K))
        xK1_inf = alpha_K1/(beta_K1 + alpha_K1)
        i_K1 = 0.430331482912*g_K1*ufl.sqrt(K_o)*(-E_K + V)*xK1_inf

        # Expressions for the Rapid time dependent potassium current component
        i_Kr = 0.430331482912*g_Kr*ufl.sqrt(K_o)*(-E_K + V)*Xr1*Xr2

        # Expressions for the Slow time dependent potassium current component
        i_Ks = g_Ks*(Xs*Xs)*(-E_Ks + V)

        # Expressions for the Fast sodium current component
        i_Na = g_Na*(m*m*m)*(-E_Na + V)*h*j

        # Expressions for the Sodium background current component
        i_b_Na = g_bna*(-E_Na + V)

        # Expressions for the L_type Ca current component
        i_CaL = 4*g_CaL*(F*F)*(-15 + V)*(-Ca_o + 0.25*Ca_ss*ufl.exp(F*(-30 +\
            2*V)/(R*T)))*d*f*f2*fCass/(R*T*(-1 + ufl.exp(F*(-30 +\
            2*V)/(R*T))))

        # Expressions for the Calcium background current component
        i_b_Ca = g_bca*(-E_Ca + V)

        # Expressions for the Transient outward current component
        i_to = g_to*(-E_K + V)*r*s

        # Expressions for the Sodium potassium pump current component
        i_NaK = K_o*P_NaK*Na_i/((K_mNa + Na_i)*(K_mk + K_o)*(1 +\
            0.1245*ufl.exp(-0.1*F*V/(R*T)) + 0.0353*ufl.exp(-F*V/(R*T))))

        # Expressions for the Sodium calcium exchanger current component
        i_NaCa = K_NaCa*(Ca_o*(Na_i*Na_i*Na_i)*ufl.exp(F*gamma*V/(R*T)) -\
            alpha*(Na_o*Na_o*Na_o)*Ca_i*ufl.exp(F*(-1 + gamma)*V/(R*T)))/((1 +\
            K_sat*ufl.exp(F*(-1 + gamma)*V/(R*T)))*(Ca_o +\
            Km_Ca)*((Km_Nai*Km_Nai*Km_Nai) + (Na_o*Na_o*Na_o)))

        # Expressions for the Calcium pump current component
        i_p_Ca = g_pCa*Ca_i/(Ca_i + K_pCa)

        # Expressions for the Potassium pump current component
        i_p_K = g_pK*(-E_K + V)/(1 + 65.4052157419*ufl.exp(-0.167224080268*V))

        # Expressions for the Membrane component
        i_Stim = 0
        current[0] = -i_b_Ca - i_K1 - i_b_Na - i_to - i_p_Ca - i_Ks - i_p_K -\
            i_NaK - i_Kr - i_Stim - i_NaCa - i_Na - i_CaL

        # Return results
        return current[0]

    def I(self, v, s, time=None):
        """
        Transmembrane current

           I = -dV/dt

        """
        return -self._I(v, s, time)

    def F(self, v, s, time=None):
        """
        Right hand side for ODE system
        """
        time = time if time else Constant(0.0)

        # Assign states
        V = v
        assert(len(s) == 18)
        Xr1, Xr2, Xs, m, h, j, d, f, f2, fCass, s, r, Ca_i, R_prime, Ca_SR,\
            Ca_ss, Na_i, K_i = s

        # Assign parameters
        P_kna = self._parameters["P_kna"]
        g_K1 = self._parameters["g_K1"]
        g_Kr = self._parameters["g_Kr"]
        g_Ks = self._parameters["g_Ks"]
        g_Na = self._parameters["g_Na"]
        g_bna = self._parameters["g_bna"]
        g_CaL = self._parameters["g_CaL"]
        g_bca = self._parameters["g_bca"]
        g_to = self._parameters["g_to"]
        K_mNa = self._parameters["K_mNa"]
        K_mk = self._parameters["K_mk"]
        P_NaK = self._parameters["P_NaK"]
        K_NaCa = self._parameters["K_NaCa"]
        K_sat = self._parameters["K_sat"]
        Km_Ca = self._parameters["Km_Ca"]
        Km_Nai = self._parameters["Km_Nai"]
        alpha = self._parameters["alpha"]
        gamma = self._parameters["gamma"]
        K_pCa = self._parameters["K_pCa"]
        g_pCa = self._parameters["g_pCa"]
        g_pK = self._parameters["g_pK"]
        Buf_c = self._parameters["Buf_c"]
        Buf_sr = self._parameters["Buf_sr"]
        Buf_ss = self._parameters["Buf_ss"]
        Ca_o = self._parameters["Ca_o"]
        EC = self._parameters["EC"]
        K_buf_c = self._parameters["K_buf_c"]
        K_buf_sr = self._parameters["K_buf_sr"]
        K_buf_ss = self._parameters["K_buf_ss"]
        K_up = self._parameters["K_up"]
        V_leak = self._parameters["V_leak"]
        V_rel = self._parameters["V_rel"]
        V_sr = self._parameters["V_sr"]
        V_ss = self._parameters["V_ss"]
        V_xfer = self._parameters["V_xfer"]
        Vmax_up = self._parameters["Vmax_up"]
        k1_prime = self._parameters["k1_prime"]
        k2_prime = self._parameters["k2_prime"]
        k3 = self._parameters["k3"]
        k4 = self._parameters["k4"]
        max_sr = self._parameters["max_sr"]
        min_sr = self._parameters["min_sr"]
        Na_o = self._parameters["Na_o"]
        Cm = self._parameters["Cm"]
        F = self._parameters["F"]
        R = self._parameters["R"]
        T = self._parameters["T"]
        V_c = self._parameters["V_c"]
        K_o = self._parameters["K_o"]

        # Init return args
        F_expressions = [ufl.zero()]*18

        # Expressions for the Reversal potentials component
        E_Na = R*T*ufl.ln(Na_o/Na_i)/F
        E_K = R*T*ufl.ln(K_o/K_i)/F
        E_Ks = R*T*ufl.ln((Na_o*P_kna + K_o)/(K_i + P_kna*Na_i))/F
        E_Ca = 0.5*R*T*ufl.ln(Ca_o/Ca_i)/F

        # Expressions for the Inward rectifier potassium current component
        alpha_K1 = 0.1/(1 + 6.14421235333e-06*ufl.exp(-0.06*E_K + 0.06*V))
        beta_K1 = (3.06060402008*ufl.exp(-0.0002*E_K + 0.0002*V) +\
            0.367879441171*ufl.exp(-0.1*E_K + 0.1*V))/(1 + ufl.exp(-0.5*V +\
            0.5*E_K))
        xK1_inf = alpha_K1/(beta_K1 + alpha_K1)
        i_K1 = 0.430331482912*g_K1*ufl.sqrt(K_o)*(-E_K + V)*xK1_inf

        # Expressions for the Rapid time dependent potassium current component
        i_Kr = 0.430331482912*g_Kr*ufl.sqrt(K_o)*(-E_K + V)*Xr1*Xr2

        # Expressions for the Xr1 gate component
        xr1_inf = 1.0/(1 + ufl.exp(-26/7 - V/7))
        alpha_xr1 = 450/(1 + ufl.exp(-9/2 - V/10))
        beta_xr1 = 6/(1 + 13.5813245226*ufl.exp(0.0869565217391*V))
        tau_xr1 = alpha_xr1*beta_xr1
        F_expressions[0] = (xr1_inf - Xr1)/tau_xr1

        # Expressions for the Xr2 gate component
        xr2_inf = 1.0/(1 + ufl.exp(11/3 + V/24))
        alpha_xr2 = 3/(1 + ufl.exp(-3 - V/20))
        beta_xr2 = 1.12/(1 + ufl.exp(-3 + V/20))
        tau_xr2 = alpha_xr2*beta_xr2
        F_expressions[1] = (xr2_inf - Xr2)/tau_xr2

        # Expressions for the Slow time dependent potassium current component
        i_Ks = g_Ks*(Xs*Xs)*(-E_Ks + V)

        # Expressions for the Xs gate component
        xs_inf = 1.0/(1 + ufl.exp(-5/14 - V/14))
        alpha_xs = 1400/ufl.sqrt(1 + ufl.exp(5/6 - V/6))
        beta_xs = 1.0/(1 + ufl.exp(-7/3 + V/15))
        tau_xs = 80 + alpha_xs*beta_xs
        F_expressions[2] = (xs_inf - Xs)/tau_xs

        # Expressions for the Fast sodium current component
        i_Na = g_Na*(m*m*m)*(-E_Na + V)*h*j

        # Expressions for the m gate component
        m_inf = 1.0/((1 + 0.00184221158117*ufl.exp(-0.110741971207*V))*(1 +\
            0.00184221158117*ufl.exp(-0.110741971207*V)))
        alpha_m = 1.0/(1 + ufl.exp(-12 - V/5))
        beta_m = 0.1/(1 + ufl.exp(-1/4 + V/200)) + 0.1/(1 + ufl.exp(7 + V/5))
        tau_m = alpha_m*beta_m
        F_expressions[3] = (-m + m_inf)/tau_m

        # Expressions for the h gate component
        h_inf = 1.0/((1 + 15212.5932857*ufl.exp(0.134589502019*V))*(1 +\
            15212.5932857*ufl.exp(0.134589502019*V)))
        alpha_h = ufl.conditional(ufl.lt(V, -40),\
            4.43126792958e-07*ufl.exp(-0.147058823529*V), 0)
        beta_h = ufl.conditional(ufl.lt(V, -40), 2.7*ufl.exp(0.079*V) +\
            310000*ufl.exp(0.3485*V), 0.77/(0.13 +\
            0.0497581410839*ufl.exp(-0.0900900900901*V)))
        tau_h = 1.0/(alpha_h + beta_h)
        F_expressions[4] = (-h + h_inf)/tau_h

        # Expressions for the j gate component
        j_inf = 1.0/((1 + 15212.5932857*ufl.exp(0.134589502019*V))*(1 +\
            15212.5932857*ufl.exp(0.134589502019*V)))
        alpha_j = ufl.conditional(ufl.lt(V, -40), (37.78 +\
            V)*(-25428*ufl.exp(0.2444*V) - 6.948e-06*ufl.exp(-0.04391*V))/(1 +\
            50262745826.0*ufl.exp(0.311*V)), 0)
        beta_j = ufl.conditional(ufl.lt(V, -40),\
            0.02424*ufl.exp(-0.01052*V)/(1 +\
            0.0039608683399*ufl.exp(-0.1378*V)), 0.6*ufl.exp(0.057*V)/(1 +\
            0.0407622039784*ufl.exp(-0.1*V)))
        tau_j = 1.0/(alpha_j + beta_j)
        F_expressions[5] = (-j + j_inf)/tau_j

        # Expressions for the Sodium background current component
        i_b_Na = g_bna*(-E_Na + V)

        # Expressions for the L_type Ca current component
        i_CaL = 4*g_CaL*(F*F)*(-15 + V)*(-Ca_o + 0.25*Ca_ss*ufl.exp(F*(-30 +\
            2*V)/(R*T)))*d*f*f2*fCass/(R*T*(-1 + ufl.exp(F*(-30 +\
            2*V)/(R*T))))

        # Expressions for the d gate component
        d_inf = 1.0/(1 + 0.344153786865*ufl.exp(-0.133333333333*V))
        alpha_d = 0.25 + 1.4/(1 + ufl.exp(-35/13 - V/13))
        beta_d = 1.4/(1 + ufl.exp(1 + V/5))
        gamma_d = 1.0/(1 + ufl.exp(5/2 - V/20))
        tau_d = alpha_d*beta_d + gamma_d
        F_expressions[6] = (-d + d_inf)/tau_d

        # Expressions for the f gate component
        f_inf = 1.0/(1 + ufl.exp(20/7 + V/7))
        tau_f = 20 + 1102.5*ufl.exp(-((27 + V)*(27 + V))/225) + 180/(1 +\
            ufl.exp(3 + V/10)) + 200/(1 + ufl.exp(13/10 - V/10))
        F_expressions[7] = (f_inf - f)/tau_f

        # Expressions for the F2 gate component
        f2_inf = 0.33 + 0.67/(1 + ufl.exp(5 + V/7))
        tau_f2 = 16/(1 + ufl.exp(3 + V/10)) + 600*ufl.exp(-((25 + V)*(25 +\
            V))/170) + 31/(1 + ufl.exp(5/2 - V/10))
        F_expressions[8] = (-f2 + f2_inf)/tau_f2

        # Expressions for the FCass gate component
        fCass_inf = 0.4 + 0.6/(1 + 400.0*(Ca_ss*Ca_ss))
        tau_fCass = 2 + 80/(1 + 400.0*(Ca_ss*Ca_ss))
        F_expressions[9] = (fCass_inf - fCass)/tau_fCass

        # Expressions for the Calcium background current component
        i_b_Ca = g_bca*(-E_Ca + V)

        # Expressions for the Transient outward current component
        i_to = g_to*(-E_K + V)*r*s

        # Expressions for the s gate component
        s_inf = 1.0/(1 + ufl.exp(4 + V/5))
        tau_s = 3 + 5/(1 + ufl.exp(-4 + V/5)) + 85*ufl.exp(-((45 + V)*(45 +\
            V))/320)
        F_expressions[10] = (s_inf - s)/tau_s

        # Expressions for the r gate component
        r_inf = 1.0/(1 + ufl.exp(10/3 - V/6))
        tau_r = 0.8 + 9.5*ufl.exp(-((40 + V)*(40 + V))/1800)
        F_expressions[11] = (r_inf - r)/tau_r

        # Expressions for the Sodium potassium pump current component
        i_NaK = K_o*P_NaK*Na_i/((K_mNa + Na_i)*(K_mk + K_o)*(1 +\
            0.1245*ufl.exp(-0.1*F*V/(R*T)) + 0.0353*ufl.exp(-F*V/(R*T))))

        # Expressions for the Sodium calcium exchanger current component
        i_NaCa = K_NaCa*(Ca_o*(Na_i*Na_i*Na_i)*ufl.exp(F*gamma*V/(R*T)) -\
            alpha*(Na_o*Na_o*Na_o)*Ca_i*ufl.exp(F*(-1 + gamma)*V/(R*T)))/((1 +\
            K_sat*ufl.exp(F*(-1 + gamma)*V/(R*T)))*(Ca_o +\
            Km_Ca)*((Km_Nai*Km_Nai*Km_Nai) + (Na_o*Na_o*Na_o)))

        # Expressions for the Calcium pump current component
        i_p_Ca = g_pCa*Ca_i/(Ca_i + K_pCa)

        # Expressions for the Potassium pump current component
        i_p_K = g_pK*(-E_K + V)/(1 + 65.4052157419*ufl.exp(-0.167224080268*V))

        # Expressions for the Calcium dynamics component
        i_up = Vmax_up/(1 + (K_up*K_up)/(Ca_i*Ca_i))
        i_leak = V_leak*(Ca_SR - Ca_i)
        i_xfer = V_xfer*(Ca_ss - Ca_i)
        kcasr = max_sr - (max_sr - min_sr)/(1 + (EC*EC)/(Ca_SR*Ca_SR))
        Ca_i_bufc = 1.0/(1 + Buf_c*K_buf_c/((Ca_i + K_buf_c)*(Ca_i + K_buf_c)))
        Ca_sr_bufsr = 1.0/(1 + Buf_sr*K_buf_sr/((Ca_SR + K_buf_sr)*(Ca_SR +\
            K_buf_sr)))
        Ca_ss_bufss = 1.0/(1 + Buf_ss*K_buf_ss/((K_buf_ss + Ca_ss)*(K_buf_ss\
            + Ca_ss)))
        F_expressions[12] = (-Cm*(i_b_Ca - 2*i_NaCa + i_p_Ca)/(2*F*V_c) +\
            i_xfer + V_sr*(-i_up + i_leak)/V_c)*Ca_i_bufc
        k1 = k1_prime/kcasr
        k2 = k2_prime*kcasr
        O = (Ca_ss*Ca_ss)*R_prime*k1/(k3 + (Ca_ss*Ca_ss)*k1)
        F_expressions[13] = -Ca_ss*R_prime*k2 + k4*(1 - R_prime)
        i_rel = V_rel*(Ca_SR - Ca_ss)*O
        F_expressions[14] = (i_up - i_leak - i_rel)*Ca_sr_bufsr
        F_expressions[15] = (V_sr*i_rel/V_ss - Cm*i_CaL/(2*F*V_ss) -\
            V_c*i_xfer/V_ss)*Ca_ss_bufss

        # Expressions for the Sodium dynamics component
        F_expressions[16] = Cm*(-i_b_Na - 3*i_NaCa - 3*i_NaK - i_Na)/(F*V_c)

        # Expressions for the Membrane component
        i_Stim = 0

        # Expressions for the Potassium dynamics component
        F_expressions[17] = Cm*(-i_K1 + 2*i_NaK - i_to - i_Ks - i_p_K - i_Kr\
            - i_Stim)/(F*V_c)

        # Return results
        return dolfin.as_vector(F_expressions)

    def num_states(self):
        return 18

    def __str__(self):
        return 'Tentusscher_panfilov_2006_epi_cell cardiac cell model'
