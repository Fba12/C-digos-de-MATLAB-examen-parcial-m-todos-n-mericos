clear; clc; close all;

rng(42); % Semilla para puntos aleatorios

% DATOS DE ENTRADA
f = [100, 120, 145, 170, 200, 235, 270, 310, 355, 405, ...
     460, 520, 585, 655, 730, 810, 895, 985, 1080, 1180, ...
     1290, 1410, 1540, 1680, 1830, 1990, 2160, 2340, 2530, 2730];

Z_mag = [152.3, 149.1, 146.8, 144.9, 142.0, 139.5, 137.9, 136.1, 134.8, 133.6, ...
         132.7, 131.9, 131.4, 131.1, 130.9, 131.0, 131.3, 131.9, 132.7, 133.8, ...
         135.2, 136.9, 138.9, 141.1, 143.5, 146.1, 149.0, 152.2, 155.6, 159.2];

n = length(f);

grado_sel = 5; %Grado 5 de ajuste robusto

% Cálculo del valor interpolado en 1000 Hz
f_target = 1000;
p_global = polyfit(f, Z_mag, grado_sel);
Z_target_interp = polyval(p_global, f_target);

indices_azar = randperm(n, 5); % 5 puntos al azar

% Vectores para almacenar los errores
errores_absolutos = zeros(1, 5);
errores_relativos = zeros(1, 5);

fprintf('=========================================================\n');
fprintf('   PROCESO DE VALIDACIÓN LEAVE-ONE-OUT (LOO) - 5 PUNTOS  \n');
fprintf('=========================================================\n');
fprintf('Iter\tPunto Retirado (Hz)\tVal Real (Ohm)\tVal Interp (Ohm)\tErr Relativo\n');
fprintf('---------------------------------------------------------\n');

for i = 1:5
    idx_test = indices_azar(i); % Punto que se saca del modelo
    
    % Dividir el conjunto de datos: entrenamiento (29) y prueba (1)
    f_train = f;
    Z_train = Z_mag;
    
    f_train(idx_test) = []; % Eliminar el punto de prueba
    Z_train(idx_test) = [];
    
    % Reajustar el polinomio seleccionado con los 29 puntos restantes
    p_loo = polyfit(f_train, Z_train, grado_sel);
    
    % Evaluar el polinomio en la coordenada del punto que fue retirado
    Z_loo_pred = polyval(p_loo, f(idx_test));
    
    % Calcular errores métricos
    errores_absolutos(i) = abs(Z_mag(idx_test) - Z_loo_pred);
    errores_relativos(i) = errores_absolutos(i) / Z_mag(idx_test);
    
    fprintf('%d\t\t%4d Hz\t\t\t%.2f\\Omega\t\t\t%.2f\\Omega\t\t\t%.4f%%\n', ...
            i, f(idx_test), Z_mag(idx_test), Z_loo_pred, errores_relativos(i)*100);
end

% Error
error_relativo_estimado = mean(errores_relativos);

fprintf('---------------------------------------------------------\n');
fprintf('\n--- RESULTADOS FINALES PEDIDOS ---\n');
fprintf('Valor interpolado de |Z| en f = %d Hz: %.4f Ohm\n', f_target, Z_target_interp);
fprintf('Error relativo estimado (LOO promedio): %.4f%%\n', error_relativo_estimado * 100);
fprintf('=========================================================\n');