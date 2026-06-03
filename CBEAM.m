% Define beam (steel, 50cm long, 2cm wide, 5mm thick)
E = 200e9;
rho = 7850;
L = 0.5;
b = 0.02;
h = 0.005;

% Calculate properties
I = (b * h^3) / 12;
A = b * h;
m_total = rho * A * L;

% Equivalent SDOF parameters
m_eq = 0.2357 * m_total;
k_eq = (3 * E * I) / L^3;

% Natural frequency
wn = sqrt(k_eq / m_eq);
fn = wn / (2 * pi);

fprintf('Stiffness k = %.2f N/m\n', k_eq)
fprintf('Equivalent mass m = %.4f kg\n', m_eq)
fprintf('Natural frequency = %.2f Hz\n', fn)

wn = 2*pi*16.55;
x0 = 0.01;
v0 = 0;

t = linspace(0,2,1000);

zeta_values = [0.05,0.15,0.30]
labels = {'\zeta = 0.05 (lightly damped)','\zeta=0.15(moderate)', '\zeta=0.3(heavily damped'};
figure; hold on;
for i = 1:3
    zeta = zeta_values(i);
    wd = wn*sqrt(1-zeta^2);

    A = x0;
    B = (v0 + zeta*wn*x0)/wd;

    x = exp(-zeta*wn*t).*(A*cos(wd*t)+ B*sin(wd*t));
    plot(t, x*1000, 'LineWidth',1.8,'DisplayName', labels{i});
    
end 
xlabel('Time(s)')
ylabel('Tip Displacement(mm)')
title('Free Vibration of Cantilever Beam Tip')
legend('Location','northeast')
grid on    

% Step 4: Time Domain Forced Response

wn = 2 * pi * 16.55;
zeta = 0.05;
F0 = 1;          % Force amplitude, 1 Newton
k = 1000;        % Stiffness from Step 1

t = linspace(0, 3, 5000);

omega_ratios = [0.5, 1.0, 1.5];
labels = {'r = 0.5 (below resonance)', 'r = 1.0 (resonance)', 'r = 1.5 (above resonance)'};
colors = {'b', 'r', 'g'};

figure;
for i = 1:3
    omega = omega_ratios(i) * wn;
    r = omega_ratios(i);

    DMF = 1 / sqrt((1 - r^2)^2 + (2*zeta*r)^2);
    X = (F0/k) * DMF;
    phi = atan2(2*zeta*r, 1 - r^2);

    x_ss = X * sin(omega*t - phi);

    subplot(3,1,i);
    plot(t, x_ss*1000, colors{i}, 'LineWidth', 1.5);
    ylabel('Displacement (mm)');
    title(labels{i});
    grid on;
end

xlabel('Time (s)');
sgtitle('Tip Displacement Under Forced Vibration');