clear; clc; close all;

% 1. Datos del Ensayo 
f = [10.0, 12.5, 15.0, 17.5, 20.0, 22.5, 25.0, 27.5, 30.0, 32.5, 35.0, 37.5, 40.0, 42.5, ...
     45.0, 47.5, 50.0, 52.5, 55.0, 57.5, 60.0, 62.5, 65.0, 67.5, 70.0, 72.5, 75.0, 77.5, ...
     80.0, 82.5, 85.0, 87.5, 90.0, 92.5, 95.0, 97.5, 100.0, 102.5, 105.0, 107.5];

V = [0.842, 0.911, 0.986, 1.062, 1.143, 1.227, 1.314, 1.401, 1.482, 1.551, 1.216, 1.048, 0.866, 0.689, ...
     0.521, 0.364, 0.223, 0.103, 0.012, -0.041, -0.057, -0.034, 0.018, 0.096, 0.197, 0.318, 0.452, 0.579, ...
     0.700, 0.809, 0.611, 0.688, 0.756, 0.811, 0.856, 0.894, 0.926, 0.954, 0.980, 1.004];

Z = [182.4, 178.9, 175.1, 171.0, 166.8, 162.7, 158.9, 155.4, 152.0, 149.0, 146.1, 145.2, 145.8, 147.3, ...
     149.9, 153.5, 158.0, 163.2, 168.9, 174.8, 180.5, 186.2, 191.5, 196.2, 200.1, 203.1, 205.2, 206.3, ...
     206.1, 204.7, 198.0, 194.4, 190.9, 187.8, 185.1, 183.0, 181.6, 180.8, 180.6, 180.9];

f_targets = [41.0, 73.0];

% 2. Función de Interpolación de Lagrange 
lagrange_deg2 = @(x, y, x_val) ...
    y(1) * ((x_val - x(2))*(x_val - x(3))) / ((x(1) - x(2))*(x(1) - x(3))) + ...
    y(2) * ((x_val - x(1))*(x_val - x(3))) / ((x(2) - x(1))*(x(2) - x(3))) + ...
    y(3) * ((x_val - x(1))*(x_val - x(2))) / ((x(3) - x(1))*(x(3) - x(2)));

% 3. Cálculos Principales
fprintf('=========================================================\n');
fprintf(' RESULTADOS DE ESTIMACIÓN: LAGRANGE VS SPLINE CÚBICO \n');
fprintf('=========================================================\n');

for i = 1:length(f_targets)
    ft = f_targets(i);
    
    % Encontrar los 3 puntos más cercanos a la frecuencia objetivo
    [~, idx_sort] = sort(abs(f - ft));
    idx_3 = sort(idx_sort(1:3)); % Seleccionamos y ordenamos los índices
    
    f_local = f(idx_3);
    V_local = V(idx_3);
    Z_local = Z(idx_3);
    
    % 3.1 Estimación por Lagrange de 2do Grado
    V_lagrange = lagrange_deg2(f_local, V_local, ft);
    Z_lagrange = lagrange_deg2(f_local, Z_local, ft);
    
    % 3.2 Estimación por Spline Cúbico Global
    V_spline = spline(f, V, ft);
    Z_spline = spline(f, Z, ft);
    
    fprintf('\n--- Evaluación en f = %.1f kHz ---\n', ft);
    fprintf('Nodos cercanos usados (Lagrange): %.1f, %.1f, %.1f kHz\n', f_local(1), f_local(2), f_local(3));
    fprintf('  V(%.1f kHz)   -> Lagrange: %.4f V   | Spline: %.4f V\n', ft, V_lagrange, V_spline);
    fprintf('  |Z|(%.1f kHz) -> Lagrange: %.4f Ohm | Spline: %.4f Ohm\n', ft, Z_lagrange, Z_spline);
end
fprintf('=========================================================\n');