clear all
close all
clc 

% Define space and time grids
x = linspace(0, 100, 400);       % Spatial domain from 0 to 100 mm
t = linspace(0, 1500, 75000);    % Time domain from 0 to 1500 ms

% Solve the PDE
opts  = odeset('RelTol',1e-13,'AbsTol',1e-18);
sol   = pdepe(0, @pdeModel, @initialConditions, @boundaryConditions, x, t,opts);

% Extract the solution
V = sol(:,:,1);                  % Membrane potential over time and space

% Plot the results
figure;
h = surf(x, t, V);
set(gca,'Fontsize',50,'FontWeight','bold');
shading interp;
view(2)
xlabel('Distance (mm)','FontWeight','bold','FontSize',50,'Interpreter','latex')
ylabel('Time t (ms)','FontWeight','bold','FontSize',50,'Interpreter','latex')
zlabel('Membrane Potential V (mV)','FontWeight','bold','FontSize',50,'Interpreter','latex');
colormap(jet(256)); 
colorbar
set(gcf,'position',[500 600 512 512],'color',[1 1 1])
caxis([-90 60]);

% --- PDE model function ---
function [c, f, s] = pdeModel(x, t, u, DuDx)
    D  = 0.154;
    g_Kr  = 0.153*0.1;
    g_Na  = 14.838; 
    g_K1  = 5.405; 
    g_CaL = 3.98e-5*5;
    K_i   = 138.3;
    Cm    = 1;
    %% parameters
    alpha = 25;
    if x <= alpha
        % epi 
        choice = 0;
        g_Ks = 0.392;
    elseif 100-alpha < x
        % endo
        choice = 1;
        g_Ks = 0.392;
    else
        % M cell
        choice = 0;   
        g_Ks = 0.098;
    end
    % PDE coefficients
    c = [Cm; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];
    f = [D ; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0] .* DuDx;
    s = fun_TP06_model(t,u,g_Kr,g_Ks,g_Na,g_K1,g_CaL,choice);
end

% --- Initial condition function ---
function u0 = initialConditions(x)
    u0 = [-86.709,0.00448,0.476,0.0087,0.00155,0.7573,0.7,3.164e-5,0.8009,0.9778,0.9953,0.3212,2.235e-8,0.9068,0.00013,3.715,0.00036,10.355,138.3]';  % Initial values 
end

% --- Boundary conditions function ---
function [pl, ql, pr, qr] = boundaryConditions(xl, ul, xr, ur, t)
    pl = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
    ql = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];
    pr = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
    qr = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];
end