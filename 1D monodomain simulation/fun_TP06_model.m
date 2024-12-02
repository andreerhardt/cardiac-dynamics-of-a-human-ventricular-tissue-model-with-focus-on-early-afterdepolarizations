function dydt = fun_TP06_model(t,y,par_g_Kr,par_g_Ks,par_g_Na,par_g_K1,par_g_CaL,choice)
%% variables
V       = y(1); 
Xr1     = y(2); 
Xr2     = y(3); 
Xs      = y(4); 
m       = y(5); 
h       = y(6); 
j       = y(7); 
d       = y(8); 
f       = y(9); 
f2      = y(10); 
fCass   = y(11);
s       = y(12); 
r       = y(13); 
R_prime = y(14); 
Ca_i    = y(15); 
Ca_SR   = y(16); 
Ca_ss   = y(17); 
Na_i    = y(18);
K_i     = y(19);
%% parameters
R        = 8314.472;
T        = 310;
F        = 96485.3415;
V_c      = 0.016404;
P_kna    = 0.03;
Cm       = 1;
g_bna    = 0.00029;
g_bca    = 0.000592;
if choice == 0
% epi and M cell
    g_to = 0.294;
elseif choice == 1
% endo
    g_to = 0.073;
end
%
g_pCa    = 0.1238;
g_pK     = 0.0146;
K_o      = 5.4;
Na_o     = 140;
K_pCa    = 0.0005;
P_NaK    = 2.724;
K_mk     = 1;
K_mNa    = 40;
K_NaCa   = 1000;
K_sat    = 0.1;
alpha_0  = 2.5;
gamma_0  = 0.35;
Km_Ca    = 1.38;
Km_Nai   = 87.5;
Ca_o     = 2;
k1_prime = 0.15;
k2_prime = 0.045;
k3       = 0.06;
k4       = 0.005;
EC       = 1.5;
max_sr   = 2.5;
min_sr   = 1;
V_rel    = 0.102;
V_xfer   = 0.0038;
K_up     = 0.00025;
V_leak   = 0.00036;
Vmax_up  = 0.006375;
Buf_c    = 0.2;
K_buf_c  = 0.001;
Buf_sr   = 10;
K_buf_sr = 0.3;
Buf_ss   = 0.4;
K_buf_ss = 0.00025;
V_sr     = 0.001094;
V_ss     = 0.00005468;
%% reversal potentials
E_Na = R*T/F*log(Na_o/Na_i);
E_K  = R*T/F*log(K_o/K_i);
E_Ks = R*T/F*log((K_o+P_kna*Na_o)/(K_i+P_kna*Na_i));
E_Ca = 0.5*R*T/F*log(Ca_o/Ca_i);
%% ion currents 
% Inward Rectifier Potassium Current
alpha_K1    = 0.1/(1+exp(0.06*(V-E_K-200)));
beta_K1     = (3*exp(0.0002*(V-E_K+100))+exp(0.1*(V-E_K-10)))/(1+exp(-0.5*(V-E_K)));
xK1_inf     = alpha_K1/(alpha_K1+beta_K1);
i_K1        = par_g_K1*xK1_inf*sqrt(K_o/5.4)*(V-E_K);
% Rapid Delayed Rectifier Current
xr1_inf     = 1/(1+exp((-26-V)/7));
alpha_xr1   = 450/(1+exp((-45-V)/10));
beta_xr1    = 6/(1+exp((V+30)/11.5));
tau_xr1     = alpha_xr1*beta_xr1;
xr2_inf     = 1/(1+exp((V+88)/24));
alpha_xr2   = 3/(1+exp((-60-V)/20));
beta_xr2    = 1.12/(1+exp((V-60)/20));
tau_xr2     = alpha_xr2*beta_xr2;
i_Kr        = par_g_Kr*sqrt(K_o/5.4)*Xr1*Xr2*(V-E_K);
% Slow Delayed Rectifier Current
xs_inf      = 1/(1+exp((-5-V)/14));
alpha_xs    = 1400/sqrt(1+exp((5-V)/6));
beta_xs     = 1/(1+exp((V-35)/15));
tau_xs      = alpha_xs*beta_xs+80;
i_Ks        = par_g_Ks*Xs^2*(V-E_Ks);
% Fast Sodium Current
m_inf       = 1/(1+exp((-56.86-V)/9.03))^2;
alpha_m     = 1/(1+exp((-60-V)/5)); 
beta_m      = 0.1/(1+exp((V+35)/5))+0.1/(1+exp((V-50)/200));
tau_m       = alpha_m*beta_m;
h_inf       = 1/(1+exp((V+71.55)/7.43))^2;
ah          = 0*(-40<=V)+(V<-40)*0.057*exp(-(V+80)/6.8);
bh          = 0.77/(0.13*(1+exp(-(V+10.66)/11.1)))*(-40<=V)+(V<-40)*(2.7*exp(0.079*V)+3.1*10^5*exp(0.3485*V));
tau_h       = (ah+bh).^-1;
j_inf       = (1+exp((V+71.55)/7.43))^-2;
aj          = 0*(-40<=V)+(V<-40)*((-2.5428*10^4*exp(0.2444*V)-6.948*10^-6*exp(-0.04391*V))*(V+37.78)/(1+exp(0.311*(V+79.23))));
bj          = 0.6*exp(0.057*V)/(1+exp(-0.1*(V+32)))*(-40<=V)+(V<-40)*(0.02424*exp(-0.01052*V)/(1+exp(-0.1378*(V+40.14))));
tau_j       = (aj+bj).^-1;
i_Na        = par_g_Na*m^3*h*j*(V-E_Na);
% L-type Calcium Current
d_inf       = 1/(1+exp((-8-V)/7.5));
alpha_d     = 1.4/(1+exp((-35-V)/13))+0.25;
beta_d      = 1.4/(1+exp((V+5)/5));
gamma_d     = 1/(1+exp((50-V)/20));
tau_d       = alpha_d*beta_d+gamma_d;
f_inf       = 1/(1+exp((V+20)/7));
tau_f       = 1102.5*exp(-(V+27)^2/225)+200/(1+exp((13-V)/10))+180/(1+exp((V+30)/10))+20;
f2_inf      = 0.67/(1+exp((V+35)/7))+0.33;
tau_f2      = 600*exp(-(V+25)^2/170)+31/(1+exp((25-V)/10))+16/(1+exp((V+30)/10));
fCass_inf   = 0.6/(1+(Ca_ss/0.05)^2)+0.4;
tau_fCass   = 80/(1+(Ca_ss/0.05)^2)+2;
i_CaL       = par_g_CaL*d*f*f2*fCass*4*(V-15)*F^2/(R*T)*(0.25*Ca_ss*exp(2*(V-15)*F/(R*T))-Ca_o)/(exp(2*(V-15)*F/(R*T))-1);
% Background Currents
i_b_Ca      = g_bca*(V-E_Ca);
i_b_Na      = g_bna*(V-E_Na);
% Transient Outward Current
if choice == 0
% epi and M cell
    s_inf   = 1/(1+exp((V+20)/5));
    tau_s   = 85*exp(-(V+45)^2/320)+5/(1+exp((V-20)/5))+3;
elseif choice == 1
% endo
    s_inf   = 1/(1+exp((V+28)/5));
    tau_s   = 1000*exp(-(V+67)^2/1000)+8;
end  
r_inf       = 1/(1+exp((20-V)/6));
tau_r       = 9.5*exp(-(V+40)^2/1800)+0.8;
i_to        = g_to*r*s*(V-E_K);
% Sodium/Potassium Pump Current
i_NaK       = P_NaK*K_o/(K_o+K_mk)*Na_i/(Na_i+K_mNa)*1/(1+0.1245*exp(-0.1*V*F/(R*T))+0.0353*exp(-V*F/(R*T)));
i_p_Ca      = g_pCa*Ca_i/(Ca_i+K_pCa);
i_p_K       = g_pK*(V-E_K)/(1+exp((25-V)/5.98));
% Sodium/Calcium Exchanger Current
i_NaCa      = K_NaCa*(exp(gamma_0*V*F/(R*T))*Na_i^3*Ca_o-exp((gamma_0-1)*V*F/(R*T))*Na_o^3*Ca_i*alpha_0)/((Km_Nai^3+Na_o^3)*(Km_Ca+Ca_o)*(1+K_sat*exp((gamma_0-1)*V*F/(R*T))));
% Calcium Dynamics
kcasr       = max_sr-(max_sr-min_sr)/(1+(EC/Ca_SR)^2);
k1          = k1_prime/kcasr;
k2          = k2_prime*kcasr;
O           = k1*(Ca_ss)^2*R_prime/(k3+k1*(Ca_ss)^2);
i_rel       = V_rel*O*(Ca_SR-Ca_ss);
i_up        = Vmax_up/(1+(K_up)^2/(Ca_i)^2);
i_leak      = V_leak*(Ca_SR-Ca_i);
i_xfer      = V_xfer*(Ca_ss-Ca_i);
Ca_i_bufc   = 1/(1+Buf_c*K_buf_c/(Ca_i+K_buf_c)^2);
Ca_sr_bufsr = 1/(1+Buf_sr*K_buf_sr/(Ca_SR+K_buf_sr)^2);
Ca_ss_bufss = 1/(1+Buf_ss*K_buf_ss/(Ca_ss+K_buf_ss)^2);
%% stimulus
stim_duration  = 1.5;
stim_amplitude = 52;
i_Stim         = stim_amplitude-stim_amplitude*(t>stim_duration);
%% ODE system
dydt = [-(i_K1+i_to+i_Kr+i_Ks+i_CaL+i_NaK+i_Na+i_b_Na+i_NaCa+i_b_Ca+i_p_K+i_p_Ca-i_Stim)/Cm;
        (xr1_inf-Xr1)/tau_xr1;
        (xr2_inf-Xr2)/tau_xr2;
        (xs_inf-Xs)/tau_xs;
        (m_inf-m)/tau_m;
        (h_inf-h)/tau_h;
        (j_inf-j)/tau_j;
        (d_inf-d)/tau_d;
        (f_inf-f)/tau_f;
        (f2_inf-f2)/tau_f2;
        (fCass_inf-fCass)/tau_fCass;
        (s_inf-s)/tau_s;
        (r_inf-r)/tau_r;
        -k2*Ca_ss*R_prime+k4*(1-R_prime);
        Ca_i_bufc*((i_leak-i_up)*V_sr/V_c+i_xfer-1*(i_b_Ca+i_p_Ca-2*i_NaCa)/(2*V_c*F));
        Ca_sr_bufsr*(i_up-(i_rel+i_leak));
        Ca_ss_bufss*(-1*i_CaL/(2*V_ss*F)+i_rel*V_sr/V_ss-i_xfer*V_c/V_ss);
        -(i_Na+i_b_Na+3*i_NaK+3*i_NaCa)/(V_c*F);
        -Cm*(i_K1+i_to+i_Kr+i_Ks-2*i_NaK+i_p_K)/(V_c*F);
        ];