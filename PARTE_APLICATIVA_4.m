% CONSTRUCCIÓN DEL SPLINE CÚBICO
clear; clc; close all;

% DATOS
f = [100, 120, 145, 170, 200, 235, 270, 310, 355, 405, ...
     460, 520, 585, 655, 730, 810, 895, 985, 1080, 1180, ...
     1290, 1410, 1540, 1680, 1830, 1990, 2160, 2340, 2530, 2730]; 

Z_mag = [152.3, 149.1, 146.8, 144.9, 142.0, 139.5, 137.9, 136.1, 134.8, 133.6, ...
         132.7, 131.9, 131.4, 131.1, 130.9, 131.0, 131.3, 131.9, 132.7, 133.8, ...
         135.2, 136.9, 138.9, 141.1, 143.5, 146.1, 149.0, 152.2, 155.6, 159.2]; 

% MALLA
f_fina = linspace(min(f), max(f), 2000);
f_target = 1000; % Frecuencia de 1000 Hz

% Parte B1
grado_sel = 5;
p_global = polyfit(f, Z_mag, grado_sel);
Z_polinomial_fina = polyval(p_global, f_fina);
Z_polinomial_target = polyval(p_global, f_target);

% Construcción y Evaluación del Spline Cúbico Natural
try
    % Intenta construir el Spline Cúbico Natural estricto usando csape (Curve Fitting Toolbox)
    spline_natural = csape(f, Z_mag, 'variational'); % 'variational' implica S''(f_1) = S''(f_n) = 0
    Z_spline_fina = fnval(spline_natural, f_fina);
    Z_spline_target = fnval(spline_natural, f_target);
catch
    % Alternativa nativa directa si no se dispone de la toolbox de curvas
    Z_spline_fina = spline(f, Z_mag, f_fina);
    Z_spline_target = spline(f, Z_mag, f_target);
end

% RESULTADOS
fprintf('=========================================================\n');
fprintf('   COMPARACIÓN DE INTERPOLACIÓN A f = %d Hz\n', f_target);
fprintf('=========================================================\n');
fprintf('Resultado con Polinomio seleccionado (Grado %d):  %.4f Ohm\n', grado_sel, Z_polinomial_target);
fprintf('Resultado con Spline Cúbico Natural:               %.4f Ohm\n', Z_spline_target);
fprintf('Diferencia absoluta entre métodos:                 %.4f Ohm\n', abs(Z_polinomial_target - Z_spline_target));
fprintf('=========================================================\n\n');

%GRÁFICO
figure('Color', [1 1 1], 'Position', [100, 100, 900, 550]);
hold on;

plot(f_fina, Z_polinomial_fina, 'LineWidth', 1.5, 'Color', [0.8500 0.3250 0.0980], ...
     'LineStyle', '--', 'DisplayName', sprintf('Polinomio Global (Grado %d)', grado_sel));
plot(f_fina, Z_spline_fina, 'LineWidth', 2.0, 'Color', [0 0.5 0], ...
     'DisplayName', 'Spline Cúbico Natural');
plot(f, Z_mag, 'o', 'MarkerFaceColor', [0 0.4470 0.7410], 'MarkerEdgeColor', 'k', ...
     'MarkerSize', 6, 'DisplayName', 'Datos experimentales (|Z|_i)');
plot(f_target, Z_polinomial_target, '^', 'MarkerFaceColor', [0.8500 0.3250 0.0980], ...
     'MarkerEdgeColor', 'k', 'MarkerSize', 8, 'DisplayName', 'Predicción Polinomio');
plot(f_target, Z_spline_target, 'v', 'MarkerFaceColor', [0 0.5 0], ...
     'MarkerEdgeColor', 'k', 'MarkerSize', 8, 'DisplayName', 'Predicción Spline');

title('Comparación de Modelos de Interpolación: Polinomio vs. Spline Cúbico', 'FontSize', 12);
xlabel('Frecuencia de excitación f (Hz)', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Magnitud de Impedancia |Z| (\Omega)', 'FontSize', 11, 'FontWeight', 'bold');
grid on;
set(gca, 'GridLineStyle', ':', 'GridAlpha', 0.5);
legend('Location', 'northeast', 'FontSize', 10);
xlim([0, 2900]);
ylim([125, 165]);

hold off;