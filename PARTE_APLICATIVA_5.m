clear; clc; close all;

%% 1. Datos Originales del Experimento (30 puntos)
f = [100, 120, 145, 170, 200, 235, 270, 310, 355, 405, ...
     460, 520, 585, 655, 730, 810, 895, 985, 1080, 1180, ...
     1290, 1410, 1540, 1680, 1830, 1990, 2160, 2340, 2530, 2730];

Z_mag = [152.3, 149.1, 146.8, 144.9, 142.0, 139.5, 137.9, 136.1, 134.8, 133.6, ...
         132.7, 131.9, 131.4, 131.1, 130.9, 131.0, 131.3, 131.9, 132.7, 133.8, ...
         135.2, 136.9, 138.9, 141.1, 143.5, 146.1, 149.0, 152.2, 155.6, 159.2];

%% 2. Construcción de la Estructura del Spline Cúbico Nativo
% Extraemos la estructura matemática por tramos PP (Piecewise Polynomial)
pp_spline = spline(f, Z_mag);

% En MATLAB, pp_spline.coefs es una matriz donde cada fila 'i' contiene los 
% coeficientes [A, B, C, D] del polinomio cúbico local:
% S_i(f) = A*(f - f_i)^3 + B*(f - f_i)^2 + C*(f - f_i) + D
coefs = pp_spline.coefs;
nodos = pp_spline.breaks;
num_intervalos = pp_spline.pieces;

%% 3. Construcción de las Estructuras de la Primera y Segunda Derivada
% Derivando analíticamente: 
% S'_i(f)  = 3*A*(f - f_i)^2 + 2*B*(f - f_i) + C
% S''_i(f) = 6*A*(f - f_i) + 2*B

coefs_derivada1 = zeros(num_intervalos, 3);
coefs_derivada2 = zeros(num_intervalos, 2);

for i = 1:num_intervalos
    coefs_derivada1(i, :) = [3*coefs(i,1), 2*coefs(i,2), coefs(i,3)];
    coefs_derivada2(i, :) = [6*coefs(i,1), 2*coefs(i,2)];
end

% Creamos nuevas estructuras continuas polinómicas (pp) para evaluar
pp_d1 = mkpp(nodos, coefs_derivada1);
pp_d2 = mkpp(nodos, coefs_derivada2);

%% 4. Evaluación Continua y Búsqueda del Mínimo Exacto (Raíz de S'(f) = 0)
f_fina = linspace(min(f), max(f), 5000);
d1_vals = ppval(pp_d1, f_fina);
d2_vals = ppval(pp_d2, f_fina);

% Localizar dónde la primera derivada cambia de signo negativo a positivo
idx_cruze = find(diff(sign(d1_vals)) > 0, 1);
f_min_analitico = f_fina(idx_cruze);

% Evaluar las propiedades exactas en ese punto crítico encontrado
Z_min_analitico = spline(f, Z_mag, f_min_analitico);
d1_min_analitico = ppval(pp_d1, f_min_analitico);
d2_min_analitico = ppval(pp_d2, f_min_analitico);

%% 5. Despliegue de Resultados por Pantalla
fprintf('=========================================================\n');
fprintf('        RESULTADOS ANALÍTICOS DE LA PARTE C\n');
fprintf('=========================================================\n');
fprintf('Ubicación exacta del mínimo (f):        %.4f Hz\n', f_min_analitico);
fprintf('Impedancia mínima calculada |Z|(f):     %.4f Ohm\n', Z_min_analitico);
fprintf('Valor de la primera derivada S''(f):     %.4e Ohm/Hz (Cercano a 0)\n', d1_min_analitico);
fprintf('Valor de la segunda derivada S''''(f):    %.4e Ohm/Hz^2\n', d2_min_analitico);
fprintf('=========================================================\n\n');

%% 6. Graficación de Curvas y Derivadas
figure('Color', [1 1 1], 'Position', [100, 100, 950, 600]);

% Subtrama 1: Comportamiento de la Impedancia y Mínimo Analítico
subplot(2, 1, 1);
hold on;
Z_fina = spline(f, Z_mag, f_fina);
plot(f_fina, Z_fina, 'LineWidth', 2, 'Color', [0 0.4470 0.7410], 'DisplayName', 'Spline |Z|(f)');
plot(f, Z_mag, 'ok', 'MarkerFaceColor', 'w', 'DisplayName', 'Nodos de medición');
plot(f_min_analitico, Z_min_analitico, 's', 'MarkerFaceColor', [0.8500 0.3250 0.0980], ...
     'MarkerSize', 8, 'DisplayName', sprintf('Mínimo analítico (%.1f Hz)', f_min_analitico));
title('Magnitud de Impedancia y Localización del Mínimo', 'FontSize', 11);
ylabel('Impedancia |Z| (\Omega)', 'FontSize', 10);
grid on; legend('Location', 'northeast');

% Subtrama 2: Primera y Segunda Derivada
subplot(2, 1, 2);
hold on;
plot(f_fina, d1_vals, 'LineWidth', 1.5, 'Color', [0.8500 0.3250 0.0980], 'DisplayName', 'Primera Derivada S''(f)');
plot(f_fina, d2_vals, 'LineWidth', 1.5, 'Color', [0.4660 0.6740 0.1880], 'DisplayName', 'Segunda Derivada S''''(f)');
plot(f_min_analitico, d1_min_analitico, 'o', 'MarkerFaceColor', 'r', 'DisplayName', 'S''(f) = 0');
line([min(f), max(f)], [0, 0], 'Color', 'k', 'LineStyle', ':'); % Línea de cero
title('Análisis de Derivadas Numéricas del Spline', 'FontSize', 11);
xlabel('Frecuencia f (Hz)', 'FontSize', 10);
ylabel('Razón de Cambio', 'FontSize', 10);
grid on; legend('Location', 'southeast');
