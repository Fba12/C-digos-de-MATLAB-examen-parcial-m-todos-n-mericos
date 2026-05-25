%PARTE A - Gráfica de datos |Z|(f)
clear; clc; close all;

f = [100, 120, 145, 170, 200, 235, 270, 310, 355, 405, ... %Valores en X
     460, 520, 585, 655, 730, 810, 895, 985, 1080, 1180, ...
     1290, 1410, 1540, 1680, 1830, 1990, 2160, 2340, 2530, 2730];

Z_mag = [152.3, 149.1, 146.8, 144.9, 142.0, 139.5, 137.9, 136.1, 134.8, 133.6, ... %Valores en Y
         132.7, 131.9, 131.4, 131.1, 130.9, 131.0, 131.3, 131.9, 132.7, 133.8, ...
         135.2, 136.9, 138.9, 141.1, 143.5, 146.1, 149.0, 152.2, 155.6, 159.2];

[min_Z, idx_min] = min(Z_mag);
f_min_estimada = f(idx_min); %Identificación del mínimo tabulado

fprintf('--- Análisis Exploratorio Inicial ---\n');
fprintf('Mínimo detectado en los datos de laboratorio:\n');
fprintf('Eje X (Frecuencia): %d Hz\n', f_min_estimada);
fprintf('Eje Y (Impedancia): %.1f Ohm\n\n', min_Z);

figure('Color', [1 1 1]); 
hold on;

%Línea de tendencia suavizada usando un spline nativo
f_fina = linspace(min(f), max(f), 1000);
Z_suave = spline(f, Z_mag, f_fina);
plot(f_fina, Z_suave, 'Color', [0.6 0.6 0.6], 'LineWidth', 1.2, 'LineStyle', '--', ...
     'DisplayName', 'Curva de tendencia estimada');

%Puntos experimentales 
plot(f, Z_mag, 'o', 'MarkerFaceColor', [0 0.4470 0.7410], 'MarkerEdgeColor', 'k', ...
     'MarkerSize', 6, 'LineWidth', 0.8, 'DisplayName', 'Datos medidos (|Z|_i)');

%Mínimo experimental
plot(f_min_estimada, min_Z, 's', 'MarkerFaceColor', [0.8500 0.3250 0.0980], ...
     'MarkerEdgeColor', 'k', 'MarkerSize', 9, 'LineWidth', 1.2, ...
     'DisplayName', sprintf('Mínimo aproximado (~%d Hz)', f_min_estimada));

%Datos de gráfica
title('Impedancia en función de la Frecuencia', 'FontSize', 12);
xlabel('Frecuencia de excitación f (Hz)', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Magnitud de Impedancia |Z| (\Omega)', 'FontSize', 11, 'FontWeight', 'bold');
grid on;
set(gca, 'GridLineStyle', ':', 'GridAlpha', 0.5); % Rejilla tenue de ingeniería
legend('Location', 'northeast', 'FontSize', 10);
xlim([0, 2900]);
ylim([125, 165]); %Limites
hold off;