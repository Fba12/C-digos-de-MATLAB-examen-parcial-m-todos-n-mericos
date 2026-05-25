clear; clc; close all;

% 1. Datos
f = [10.0, 12.5, 15.0, 17.5, 20.0, 22.5, 25.0, 27.5, 30.0, 32.5, 35.0, 37.5, 40.0, 42.5, ...
     45.0, 47.5, 50.0, 52.5, 55.0, 57.5, 60.0, 62.5, 65.0, 67.5, 70.0, 72.5, 75.0, 77.5, ...
     80.0, 82.5, 85.0, 87.5, 90.0, 92.5, 95.0, 97.5, 100.0, 102.5, 105.0, 107.5];

V = [0.842, 0.911, 0.986, 1.062, 1.143, 1.227, 1.314, 1.401, 1.482, 1.551, 1.216, 1.048, 0.866, 0.689, ...
     0.521, 0.364, 0.223, 0.103, 0.012, -0.041, -0.057, -0.034, 0.018, 0.096, 0.197, 0.318, 0.452, 0.579, ...
     0.700, 0.809, 0.611, 0.688, 0.756, 0.811, 0.856, 0.894, 0.926, 0.954, 0.980, 1.004];

h = 2.5; % Espaciamiento constante en kHz

% 2. Construcción de la estructura del Spline 
pp_spline = spline(f, V);
coefs = pp_spline.coefs;
nodos = pp_spline.breaks;
num_pieces = pp_spline.pieces;

% S'_i(f) = 3*A*(f - f_i)^2 + 2*B*(f - f_i) + C
coefs_d1 = zeros(num_pieces, 3);
for i = 1:num_pieces
    coefs_d1(i, :) = [3*coefs(i,1), 2*coefs(i,2), coefs(i,3)];
end
pp_d1 = mkpp(nodos, coefs_d1);

% 3. Cálculos de Derivadas 
f_eval = [40.0, 70.0, 100.0];

fprintf('=========================================================================\n');
fprintf('     RESULTADOS DE DERIVACIÓN NUMÉRICA (dV/df en V/kHz) \n');
fprintf('=========================================================================\n\n');

% --- REQUERIMIENTO 1 y 4: Puntos Internos ---
for i = 1:length(f_eval)
    fe = f_eval(i);
    idx = find(f == fe);
    
    % Diferencia centrada de orden 2
    % dV/df = ( V(x+h) - V(x-h) ) / (2h)
    dv_c2 = (V(idx+1) - V(idx-1)) / (2*h);
    
    % Diferencia centrada de orden 4 (Requiere dos puntos a cada lado)
    % Solo se puede usar si el punto está lo suficientemente alejado de los bordes
    if idx > 2 && idx < length(f)-1
        % dV/df = ( -V(x+2h) + 8V(x+h) - 8V(x-h) + V(x-2h) ) / (12h)
        dv_c4 = (-V(idx+2) + 8*V(idx+1) - 8*V(idx-1) + V(idx-2)) / (12*h);
        str_c4 = sprintf('%.4f V/kHz', dv_c4);
    else
        str_c4 = 'No disponible (borde)';
    end
    
    % Derivación analítica del Spline Cúbico
    dv_spline = ppval(pp_d1, fe);
    
    fprintf('--- Frecuencia f = %.1f kHz ---\n', fe);
    fprintf('  Diferencia Centrada Orden 2: %.4f V/kHz\n', dv_c2);
    fprintf('  Diferencia Centrada Orden 4: %s\n', str_c4);
    fprintf('  Derivada Analítica del Spline: %.4f V/kHz\n\n', dv_spline);
end

% --- REQUERIMIENTO 2: Extremo Inferior f = 10.0 kHz ---
% Fórmula progresiva de orden 2 (Requiere los índices 1, 2 y 3)
% dV/df = ( -3V(x) + 4V(x+h) - V(x+2h) ) / (2h)
dv_prog2 = (-3*V(1) + 4*V(2) - V(3)) / (2*h);
dv_spline_10 = ppval(pp_d1, 10.0);

fprintf('--- Extremo Inferior f = 10.0 kHz ---\n');
fprintf('  Fórmula Progresiva Orden 2:  %.4f V/kHz\n', dv_prog2);
fprintf('  Derivada Analítica del Spline: %.4f V/kHz\n', dv_spline_10);
fprintf('=========================================================================\n');