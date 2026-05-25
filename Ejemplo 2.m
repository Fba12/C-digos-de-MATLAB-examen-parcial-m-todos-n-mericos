clear; clc; close all;

% Datos (17 puntos)
% Tiempo (Horas)
tiempo = [0, 1.5, 3.0, 4.5, 6.0, 7.5, 9.0, 10.5, 12.0, 13.5, 15.0, 16.5, 18.0, 19.5, 21.0, 22.5, 24.0];

% Temperatura (°C)
temperatura = [180.5, 182.1, 185.4, 190.2, 195.0, 198.6, 199.1, 196.4, 191.3, 186.0, 182.4, 180.1, 179.5, 180.7, 183.2, 186.9, 191.0];

%% 2. Malla Fina para Evaluación Continua
% Creamos un vector de tiempo continuo (cada minuto) para interpolar
tiempo_fino = linspace(min(tiempo), max(tiempo), 1440);

%% 3. Interpolación por Splines Cúbicos
% La función 'spline' de MATLAB calcula los polinomios de grado 3 
% que conectan de forma suave cada par de datos consecutivos.
temp_interpolada = spline(tiempo, temperatura, tiempo_fino);

%% 4. Análisis de un Punto Crítico Específico
% El operador quiere estimar la temperatura exacta a las 11.3 horas (11:18 AM)
tiempo_analisis = 11.3;
temp_analisis = spline(tiempo, temperatura, tiempo_analisis);

fprintf('=========================================================\n');
fprintf('        ANÁLISIS DE INTERPOLACIÓN POR SPLINES\n');
fprintf('=========================================================\n');
fprintf('Temperatura estimada a las %.1f horas: %.2f °C\n', tiempo_analisis, temp_analisis);
fprintf('=========================================================\n\n');

%% 5. Graficación de los Resultados
figure('Color', [1 1 1], 'Position', [100, 100, 850, 500]);
hold on;

% Graficar la curva continua generada por el spline
plot(tiempo_fino, temp_interpolada, 'LineWidth', 2, 'Color', [0.8500 0.3250 0.0980], ...
     'DisplayName', 'Perfil térmico reconstruido (Spline Cúbico)');

% Mostrar los puntos reales de control recolectados por el sensor
plot(tiempo, temperatura, 'o', 'MarkerFaceColor', [0 0.4470 0.7410], 'MarkerEdgeColor', 'k', ...
     'MarkerSize', 7, 'DisplayName', 'Lecturas del sensor (Cada 1.5h)');

% Destacar el punto interpolado de análisis en la gráfica
plot(tiempo_analisis, temp_analisis, 'p', 'MarkerFaceColor', [0.9290 0.6940 0.1250], ...
     'MarkerEdgeColor', 'k', 'MarkerSize', 12, 'DisplayName', 'Estimación crítica (11.3h)');

%% 6. Formato Estético e Ingeniería
title('Monitoreo Continuo del Reactor Químico mediante Splines Cúbicos', 'FontSize', 12);
xlabel('Tiempo transcurrido (Horas)', 'FontSize', 11);
ylabel('Temperatura del núcleo (°C)', 'FontSize', 11);

grid on;
set(gca, 'GridLineStyle', ':', 'GridAlpha', 0.5); % Rejilla tenue scannable
legend('Location', 'south', 'FontSize', 10);

% Ajustar límites de visualización con márgenes cómodos
xlim([-1, 25]);
ylim([175, 205]);

hold off;