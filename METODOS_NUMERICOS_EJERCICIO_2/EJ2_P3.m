clear; clc; close all;

% 1. Datos 
f = [10.0, 12.5, 15.0, 17.5, 20.0, 22.5, 25.0, 27.5, 30.0, 32.5, 35.0, 37.5, 40.0, 42.5, ...
     45.0, 47.5, 50.0, 52.5, 55.0, 57.5, 60.0, 62.5, 65.0, 67.5, 70.0, 72.5, 75.0, 77.5, ...
     80.0, 82.5, 85.0, 87.5, 90.0, 92.5, 95.0, 97.5, 100.0, 102.5, 105.0, 107.5];

V = [0.842, 0.911, 0.986, 1.062, 1.143, 1.227, 1.314, 1.401, 1.482, 1.551, 1.216, 1.048, 0.866, 0.689, ...
     0.521, 0.364, 0.223, 0.103, 0.012, -0.041, -0.057, -0.034, 0.018, 0.096, 0.197, 0.318, 0.452, 0.579, ...
     0.700, 0.809, 0.611, 0.688, 0.756, 0.811, 0.856, 0.894, 0.926, 0.954, 0.980, 1.004];

% 2. Identificación Automática de Intervalos con Cambio de Signo
fprintf('=========================================================================\n');
fprintf('        ANÁLISIS DE CRUCES POR CERO (CAMBIOS DE SIGNO) \n');
fprintf('=========================================================================\n');

% Buscamos dónde V(i) y V(i+1) tienen signos opuestos (su producto es negativo)
idx_cambios = find(V(1:end-1) .* V(2:end) < 0);

for k = 1:length(idx_cambios)
    idx = idx_cambios(k);
    fprintf('Cruce #%d detected entre: [%.1f kHz] y [%.1f kHz]\n', ...
            k, f(idx), f(idx+1));
    fprintf('   Valores de Voltaje:   V(%.1f)=%.3f V  -->  V(%.1f)=%.3f V\n\n', ...
            f(idx), V(idx), f(idx+1), V(idx+1));
end

% 3. Bisección
tol = 1e-6; max_iter = 50;

% Función anónima para evaluar bisección lineal tramo a tramo (aproximada)
function [raiz, iter] = biseccion_tabla(f_vector, V_vector, idx_start, tol, max_iter)
    a = f_vector(idx_start);
    b = f_vector(idx_start + 1);
    Va = V_vector(idx_start);
    Vb = V_vector(idx_start + 1);
    
    % Recta local: V(x) = Va + (Vb - Va)/(b - a) * (x - a)
    g_lineal = @(x) Va + ((Vb - Va)/(b - a)) * (x - a);
    
    iter = 0;
    while (b - a)/2 > tol && iter < max_iter
        iter = iter + 1;
        c = (a + b) / 2;
        if g_lineal(c) == 0, break; end
        if g_lineal(a) * g_lineal(c) < 0, b = c; else, a = c; end
    end
    raiz = (a + b) / 2;
end

% 4. Refinamiento de Raíces mediante el Spline Cúbico
% Función anónima global para evaluar la curva del spline
g_spline = @(x) spline(f, V, x);

function [raiz, iter] = biseccion_spline(func, a, b, tol, max_iter)
    iter = 0;
    while (b - a)/2 > tol && iter < max_iter
        iter = iter + 1;
        c = (a + b) / 2;
        if func(c) == 0, break; end
        if func(a) * func(c) < 0, b = c; else, a = c; end
    end
    raiz = (a + b) / 2;
end

% 5. Resultados
fprintf('=========================================================================\n');
fprintf('     COMPARACIÓN DE RAÍCES: BISECCIÓN LOCAL VS REFINAMIENTO SPLINE\n');
fprintf('=========================================================================\n');

for k = 1:length(idx_cambios)
    idx = idx_cambios(k);
    
    % Raíz calculada asumiendo comportamiento lineal entre los dos puntos
    [r_bis, it_bis] = biseccion_tabla(f, V, idx, tol, max_iter);
    
    % Raíz refinada evaluando la curva real del Spline Cúbico Natural
    [r_spline, it_spline] = biseccion_spline(g_spline, f(idx), f(idx+1), tol, max_iter);
    
    fprintf('--- Cruce por Cero #%d ---\n', k);
    fprintf('  Raíz por Bisección Lineal:  %.4f kHz (Iteraciones: %d)\n', r_bis, it_bis);
    fprintf('  Raíz Refinada con Spline:   %.4f kHz (Iteraciones: %d)\n', r_spline, it_spline);
    fprintf('  Diferencia o Ajuste Numérico:  %.4f kHz\n\n', abs(r_bis - r_spline));
end
fprintf('=========================================================================\n');