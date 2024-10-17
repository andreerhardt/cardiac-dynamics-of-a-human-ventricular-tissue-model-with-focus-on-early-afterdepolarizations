function out = TP06_endo
out{1} = @init;
out{2} = @fun_eval;
out{3} = [];
out{4} = [];
out{5} = [];
out{6} = [];
out{7} = [];
out{8} = [];
out{9} = [];

% --------------------------------------------------------------------------
function dydt = fun_eval(t,kmrgd,par_g_Kr,par_g_Ks,par_g_Na,par_g_K1,par_g_CaL,par_Cm)
R=8314.472;
T=310;
F=96485.3415;
V_c=0.016404;
P_kna=0.03;
g_bna=0.00029;
g_bca=0.000592;
g_to=0.073;
g_pCa=0.1238;
g_pK=0.0146;
K_o=5.4;
Na_o=140;
K_pCa=0.0005;
P_NaK=2.724;
K_mk=1;
K_mNa=40;
K_NaCa=1000;
K_sat=0.1;
alpha_0=2.5;
gamma_0=0.35;
Km_Ca=1.38;
Km_Nai=87.5;
Ca_o=2;
k1_prime=0.15;
k2_prime=0.045;
k3=0.06;
k4=0.005;
EC=1.5;
max_sr=2.5;
min_sr=1;
V_rel=0.102;
V_xfer=0.0038;
K_up=0.00025;
V_leak=0.00036;
Vmax_up=0.006375;
Buf_c=0.2;
K_buf_c=0.001;
Buf_sr=10;
K_buf_sr=0.3;
Buf_ss=0.4;
K_buf_ss=0.00025;
V_sr=0.001094;
V_ss=0.00005468;
E_Na=R*T/F*log(Na_o/kmrgd(18));
E_K=R*T/F*log(K_o/kmrgd(19));
E_Ks=R*T/F*log((K_o+P_kna*Na_o)/(kmrgd(19)+P_kna*kmrgd(18)));
E_Ca=0.5*R*T/F*log(Ca_o/kmrgd(15));
alpha_K1=0.1/(1+exp(0.06*(kmrgd(1)-E_K-200)));
beta_K1=(3*exp(0.0002*(kmrgd(1)-E_K+100))+exp(0.1*(kmrgd(1)-E_K-10)))/(1+exp(-0.5*(kmrgd(1)-E_K)));
xK1_inf=alpha_K1/(alpha_K1+beta_K1);
i_K1=par_g_K1*xK1_inf*sqrt(K_o/5.4)*(kmrgd(1)-E_K);
i_Kr=par_g_Kr*sqrt(K_o/5.4)*kmrgd(2)*kmrgd(3)*(kmrgd(1)-E_K);
xr1_inf=1/(1+exp((-26-kmrgd(1))/7));
alpha_xr1=450/(1+exp((-45-kmrgd(1))/10));
beta_xr1=6/(1+exp((kmrgd(1)+30)/11.5));
tau_xr1=alpha_xr1*beta_xr1;
xr2_inf=1/(1+exp((kmrgd(1)+88)/24));
alpha_xr2=3/(1+exp((-60-kmrgd(1))/20));
beta_xr2=1.12/(1+exp((kmrgd(1)-60)/20));
tau_xr2=alpha_xr2*beta_xr2;
i_Ks=par_g_Ks*kmrgd(4)^2*(kmrgd(1)-E_Ks);
xs_inf=1/(1+exp((-5-kmrgd(1))/14));
alpha_xs=1400/sqrt(1+exp((5-kmrgd(1))/6));
beta_xs=1/(1+exp((kmrgd(1)-35)/15));
tau_xs=alpha_xs*beta_xs+80;
i_Na=par_g_Na*kmrgd(5)^3*kmrgd(6)*kmrgd(7)*(kmrgd(1)-E_Na);
m_inf=1/(1+exp((-56.86-kmrgd(1))/9.03))^2;
alpha_m=1/(1+exp((-60-kmrgd(1))/5));
beta_m=0.1/(1+exp((kmrgd(1)+35)/5))+0.1/(1+exp((kmrgd(1)-50)/200));
tau_m=alpha_m*beta_m;
h_inf=(1+exp((kmrgd(1)+71.55)/7.43))^-2;
ah=0*(-40<=kmrgd(1))+(kmrgd(1)<-40)*0.057*exp(-(kmrgd(1)+80)/6.8);
bh=0.77/(0.13*(1+exp(-(kmrgd(1)+10.66)/11.1)))*(-40<=kmrgd(1))+(kmrgd(1)<-40)*(2.7*exp(0.079*kmrgd(1))+3.1*10^5*exp(0.3485*kmrgd(1)));
tau_h=(ah+bh)^-1;
j_inf=(1+exp((kmrgd(1)+71.55)/7.43))^-2;
aj=0*(-40<=kmrgd(1))+(kmrgd(1)<-40)*((-2.5428*10^4*exp(0.2444*kmrgd(1))-6.948*10^-6*exp(-0.04391*kmrgd(1)))*(kmrgd(1)+37.78)/(1+exp(0.311*(kmrgd(1)+79.23))));
bj=0.6*exp(0.057*kmrgd(1))/(1+exp(-0.1*(kmrgd(1)+32)))*(-40<=kmrgd(1))+(kmrgd(1)<-40)*(0.02424*exp(-0.01052*kmrgd(1))/(1+exp(-0.1378*(kmrgd(1)+40.14))));
tau_j=(aj+bj)^-1;
i_b_Na=g_bna*(kmrgd(1)-E_Na);
i_CaL=par_g_CaL*kmrgd(8)*kmrgd(9)*kmrgd(10)*kmrgd(11)*4*(kmrgd(1)-15)*F^2/(R*T)*(0.25*kmrgd(17)*exp(2*(kmrgd(1)-15)*F/(R*T))-Ca_o)/(exp(2*(kmrgd(1)-15)*F/(R*T))-1);
d_inf=1/(1+exp((-8-kmrgd(1))/7.5));
alpha_d=1.4/(1+exp((-35-kmrgd(1))/13))+0.25;
beta_d=1.4/(1+exp((kmrgd(1)+5)/5));
gamma_d=1/(1+exp((50-kmrgd(1))/20));
tau_d=alpha_d*beta_d+gamma_d;
f_inf=1/(1+exp((kmrgd(1)+20)/7));
tau_f=1102.5*exp(-(kmrgd(1)+27)^2/225)+200/(1+exp((13-kmrgd(1))/10))+180/(1+exp((kmrgd(1)+30)/10))+20;
f2_inf=0.67/(1+exp((kmrgd(1)+35)/7))+0.33;
tau_f2=600*exp(-(kmrgd(1)+25)^2/170)+31/(1+exp((25-kmrgd(1))/10))+16/(1+exp((kmrgd(1)+30)/10));
fCass_inf=0.6/(1+(kmrgd(17)/0.05)^2)+0.4;
tau_fCass=80/(1+(kmrgd(17)/0.05)^2)+2;
i_b_Ca=g_bca*(kmrgd(1)-E_Ca);
i_to=g_to*kmrgd(13)*kmrgd(12)*(kmrgd(1)-E_K);
s_inf=1/(1+exp((kmrgd(1)+28)/5));
tau_s=1000*exp(-(kmrgd(1)+67)^2/1000)+8;
r_inf=1/(1+exp((20-kmrgd(1))/6));
tau_r=9.5*exp(-(kmrgd(1)+40)^2/1800)+0.8;
i_NaK=P_NaK*K_o/(K_o+K_mk)*kmrgd(18)/(kmrgd(18)+K_mNa)*1/(1+0.1245*exp(-0.1*kmrgd(1)*F/(R*T))+0.0353*exp(-kmrgd(1)*F/(R*T)));
i_NaCa=K_NaCa*(exp(gamma_0*kmrgd(1)*F/(R*T))*kmrgd(18)^3*Ca_o-exp((gamma_0-1)*kmrgd(1)*F/(R*T))*Na_o^3*kmrgd(15)*alpha_0)/((Km_Nai^3+Na_o^3)*(Km_Ca+Ca_o)*(1+K_sat*exp((gamma_0-1)*kmrgd(1)*F/(R*T))));
i_p_Ca=g_pCa*kmrgd(15)/(kmrgd(15)+K_pCa);
i_p_K=g_pK*(kmrgd(1)-E_K)/(1+exp((25-kmrgd(1))/5.98));
kcasr=max_sr-(max_sr-min_sr)/(1+(EC/kmrgd(16))^2);
k1=k1_prime/kcasr;
k2=k2_prime*kcasr;
O=k1*(kmrgd(17))^2*kmrgd(14)/(k3+k1*(kmrgd(17))^2);
i_rel=V_rel*O*(kmrgd(16)-kmrgd(17));
i_up=Vmax_up/(1+(K_up)^2/(kmrgd(15))^2);
i_leak=V_leak*(kmrgd(16)-kmrgd(15));
i_xfer=V_xfer*(kmrgd(17)-kmrgd(15));
Ca_i_bufc=1/(1+Buf_c*K_buf_c/(kmrgd(15)+K_buf_c)^2);
Ca_sr_bufsr=1/(1+Buf_sr*K_buf_sr/(kmrgd(16)+K_buf_sr)^2);
Ca_ss_bufss=1/(1+Buf_ss*K_buf_ss/(kmrgd(17)+K_buf_ss)^2);
stim_duration=2;
stim_amplitude=52;
i_Stim=stim_amplitude-stim_amplitude*(t>stim_duration);
dydt=[-(i_K1+i_to+i_Kr+i_Ks+i_CaL+i_NaK+i_Na+i_b_Na+i_NaCa+i_b_Ca+i_p_K+i_p_Ca-i_Stim)/par_Cm;
(xr1_inf-kmrgd(2))/tau_xr1;
(xr2_inf-kmrgd(3))/tau_xr2;
(xs_inf-kmrgd(4))/tau_xs;
(m_inf-kmrgd(5))/tau_m;
(h_inf-kmrgd(6))/tau_h;
(j_inf-kmrgd(7))/tau_j;
(d_inf-kmrgd(8))/tau_d;
(f_inf-kmrgd(9))/tau_f;
(f2_inf-kmrgd(10))/tau_f2;
(fCass_inf-kmrgd(11))/tau_fCass;
(s_inf-kmrgd(12))/tau_s;
(r_inf-kmrgd(13))/tau_r;
-k2*kmrgd(17)*kmrgd(14)+k4*(1-kmrgd(14));
Ca_i_bufc*((i_leak-i_up)*V_sr/V_c+i_xfer-par_Cm*(i_b_Ca+i_p_Ca-2*i_NaCa)/(2*V_c*F));
Ca_sr_bufsr*(i_up-(i_rel+i_leak));
Ca_ss_bufss*(-par_Cm*i_CaL/(2*V_ss*F)+i_rel*V_sr/V_ss-i_xfer*V_c/V_ss);
-par_Cm*(i_Na+i_b_Na+3*i_NaK+3*i_NaCa)/(V_c*F);
-par_Cm*(i_K1+i_to+i_Kr+i_Ks-2*i_NaK+i_p_K)/(V_c*F);];

% --------------------------------------------------------------------------
function [tspan,y0,options] = init
handles = feval(TP06_endo);
y0=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
options = odeset('Jacobian',[],'JacobianP',[],'Hessians',[],'HessiansP',[]);
tspan = [0 10];

% --------------------------------------------------------------------------
function jac = jacobian(t,kmrgd,par_g_Kr,par_g_Ks,par_g_Na,par_g_K1,par_g_CaL,par_Cm)
% --------------------------------------------------------------------------
function jacp = jacobianp(t,kmrgd,par_g_Kr,par_g_Ks,par_g_Na,par_g_K1,par_g_CaL,par_Cm)
% --------------------------------------------------------------------------
function hess = hessians(t,kmrgd,par_g_Kr,par_g_Ks,par_g_Na,par_g_K1,par_g_CaL,par_Cm)
% --------------------------------------------------------------------------
function hessp = hessiansp(t,kmrgd,par_g_Kr,par_g_Ks,par_g_Na,par_g_K1,par_g_CaL,par_Cm)
%---------------------------------------------------------------------------
function tens3  = der3(t,kmrgd,par_g_Kr,par_g_Ks,par_g_Na,par_g_K1,par_g_CaL,par_Cm)
%---------------------------------------------------------------------------
function tens4  = der4(t,kmrgd,par_g_Kr,par_g_Ks,par_g_Na,par_g_K1,par_g_CaL,par_Cm)
%---------------------------------------------------------------------------
function tens5  = der5(t,kmrgd,par_g_Kr,par_g_Ks,par_g_Na,par_g_K1,par_g_CaL,par_Cm)
