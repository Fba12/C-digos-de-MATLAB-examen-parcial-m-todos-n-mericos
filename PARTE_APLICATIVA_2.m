clear; clc; close all;

%% 1. Vectores de Datos Originales (30 puntos)
f = [100, 120, 145, 170, 200, 235, 270, 310, 355, 405, ...
     460, 520, 585, 655, 730, 810, 895, 985, 1080, 1180, ...
     1290, 1410, 1540, 1680, 1830, 1990, 2160, 2340, 2530, 2730];

Z_mag = [152.3, 149.1, 146.8, 144.9, 142.0, 139.5, 137.9, 136.1, 134.8, 133.6, ...
         132.7, 131.9, 131.4, 131.1, 130.9, 131.0, 131.3, 131.9, 132.7, 133.8, ...
         135.2, 136.9, 138.9, 141.1, 143.5, 146.1, 149.0, 152.2, 155.6, 159.2];

n = length(f); % Número de puntos (30)
grado = n - 1; % Grado del polinomio exacto (29)

% Malla fina para evaluar y graficar el comportamiento continuo
f_fina = linspace(min(f), max(f), 2000);

%% =======================================================================
%% METODO 1: MÉTODO MATRICIAL (VANDERMONDE)
%% =======================================================================
% Construcción de la matriz de Vandermonde manual V*c = Z
V = zeros(n, n);
for i = 1:n
    for j = 1:n
        V(i, j) = f(i)^(j-1); 
    end
end

% Advertencia sobre el mal condicionamiento numérico de Vandermonde
cond_V = cond(V);
fprintf('--- Análisis de la Matriz de Vandermonde ---\n');
fprintf('Número de condición de la matriz V: %e\n', cond_V);
if cond_V > 1e12
    fprintf('AVISO: La matriz está extremadamente mal condicionada.\n');
    fprintf('Los coeficientes calculados pueden perder precisión por redondeo.\n\n');
end

% Resolver el sistema de ecuaciones para obtener los coeficientes [c_0, c_1, ..., c_29]
coef_matricial = V \ Z_mag'; 

% Evaluar el polinomio matricial en la malla fina usando el método de Horner
Z_matricial = zeros(size(f_fina));
for i = 1:length(f_fina)
    val = 0;
    for j = n:-1:1
        val = val * f_fina(i) + coef_matricial(j);
    end
    Z_matricial(i) = val;
end

%% =======================================================================
%% METODO 2: INTERPOLACIÓN DE LAGRANGE
%% =======================================================================
Z_lagrange = zeros(size(f_fina));

% Implementación algorítmica de los polinomios base de Lagrange
for k = 1:length(f_fina)
    suma_lagrange = 0;
    for i = 1:n
        % Calcular el polinomio productor L_i(f)
        L_i = 1;
        for j = 1:n
            if j ~= i
                L_i = L_i * (f_fina(k) - f(j)) / (f(i) - f(j));
            end
        end
        suma_lagrange = suma_lagrange + Z_mag(i) * L_i;
    end
    Z_lagrange(k) = suma_lagrange;
end

%% =======================================================================
%% 3. VISUALIZACIÓN Y COMPARACIÓN DE RESULTADOS
%% =======================================================================
figure('Color', [1 1 1], 'Position', [100, 100, 850, 500]);
hold on;

% Graficar comportamiento del polinomio por Método Matricial
plot(f_fina, Z_matricial, 'LineWidth', 2, 'Color', [0.8500 0.3250 0.0980], ...
     'DisplayName', sprintf('Polinomio Matricial (Grado %d)', grado));

% Graficar comportamiento por Interpolación de Lagrange
plot(f_fina, Z_lagrange, 'LineStyle', '--', 'LineWidth', 1.5, 'Color', [0.4660 0.6740 0.1880], ...
     'DisplayName', sprintf('Polinomio de Lagrange (Grado %d)', grado));

% Mostrar los puntos de control originales del experimento
plot(f, Z_mag, 'o', 'MarkerFaceColor', [0 0.4470 0.7410], 'MarkerEdgeColor', 'k', ...
     'MarkerSize', 6, 'DisplayName', 'Datos experimentales originales');

title(sprintf('Comparación de Interpolación Global de Grado %d', grado), 'FontSize', 12);
xlabel('Frecuencia f (Hz)', 'FontSize', 11);
ylabel('Magnitud de Impedancia |Z| (\Omega)', 'FontSize', 11);

grid on;
set(gca, 'GridLineStyle', ':', 'GridAlpha', 0.6);
legend('Location', 'south', 'FontSize', 10);
ylim([0, 200]); % Ajustado para visualizar posibles oscilaciones descontroladas
hold off;
