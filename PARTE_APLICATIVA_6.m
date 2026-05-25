clear; clc; close all;
%DATOS
f = [100, 120, 145, 170, 200, 235, 270, 310, 355, 405, ...
     460, 520, 585, 655, 730, 810, 895, 985, 1080, 1180, ...
     1290, 1410, 1540, 1680, 1830, 1990, 2160, 2340, 2530, 2730];

Z_mag = [152.3, 149.1, 146.8, 144.9, 142.0, 139.5, 137.9, 136.1, 134.8, 133.6, ...
         132.7, 131.9, 131.4, 131.1, 130.9, 131.0, 131.3, 131.9, 132.7, 133.8, ...
         135.2, 136.9, 138.9, 141.1, 143.5, 146.1, 149.0, 152.2, 155.6, 159.2];

Z_th = 150; % Umbral de impedancia 

% Spline Cúbico y su primera derivada analítica
pp_spline = spline(f, Z_mag);
coefs = pp_spline.coefs;
nodos = pp_spline.breaks;
num_intervalos = pp_spline.pieces;

coefs_d1 = zeros(num_intervalos, 3);
for i = 1:num_intervalos
    coefs_d1(i, :) = [3*coefs(i,1), 2*coefs(i,2), coefs(i,3)];
end
pp_d1 = mkpp(nodos, coefs_d1);

g  = @(x) ppval(pp_spline, x) - Z_th; % Función objetivo g(f) = |Z|(f) - 150
dg = @(x) ppval(pp_d1, x);            % Derivada g'(f) = S'(f)

% Parametros para errores
tol = 1e-6;      % Tolerancia para 4+ cifras significativas
max_iter = 50;   % Límite de seguridad

% Intervalos y valores iniciales observados en los datos tabulados:
% Raíz 1 (Baja freq): Entre 100 Hz (152.3) y 120 Hz (149.1)
int_1 = [100, 120];  x0_1 = 110; 

% Raíz 2 (Alta freq): Entre 2160 Hz (149.0) y 2340 Hz (152.2)
int_2 = [2160, 2340]; x0_2 = 2250;

fprintf('=========================================================\n');
fprintf('   BÚSQUEDA DE RAÍCES: |Z|(f) = 150 Ohm \n');
fprintf('=========================================================\n\n');

%Bisección
fprintf('--- MÉTODO DE BISECCIÓN ---\n');
function [raiz, iter] = biseccion(func, a, b, tol, max_iter)
    iter = 0;
    while (b - a)/2 > tol && iter < max_iter
        iter = iter + 1;
        c = (a + b) / 2;
        if func(c) == 0
            break;
        elseif func(a) * func(c) < 0
            b = c;
        else
            a = c;
        end
    end
    raiz = (a + b) / 2;
end

[raiz1_bis, iter1_bis] = biseccion(g, int_1(1), int_1(2), tol, max_iter);
[raiz2_bis, iter2_bis] = biseccion(g, int_2(1), int_2(2), tol, max_iter);

fprintf('Raíz 1 (Baja frec):  %.4f Hz (Iteraciones: %d)\n', raiz1_bis, iter1_bis);
fprintf('Raíz 2 (Alta frec): %.4f Hz (Iteraciones: %d)\n\n', raiz2_bis, iter2_bis);

%Newton-Raphson
fprintf('--- MÉTODO DE NEWTON-RAPHSON ---\n');

function [raiz, iter] = newton(func, dfunc, x0, tol, max_iter)
    iter = 0;
    x = x0;
    while iter < max_iter
        iter = iter + 1;
        x_new = x - func(x) / dfunc(x);
        if abs(x_new - x) < tol
            x = x_new;
            break;
        end
        x = x_new;
    end
    raiz = x;
end

[raiz1_newton, iter1_newton] = newton(g, dg, x0_1, tol, max_iter);
[raiz2_newton, iter2_newton] = newton(g, dg, x0_2, tol, max_iter);

fprintf('Raíz 1 (Baja frec):  %.4f Hz (Iteraciones: %d)\n', raiz1_newton, iter1_newton);
fprintf('Raíz 2 (Alta frec): %.4f Hz (Iteraciones: %d)\n\n', raiz2_newton, iter2_newton);

% Sensibilidad
fprintf('=========================================================\n');
fprintf('   ANÁLISIS DE SENSIBILIDAD EN LÍMITE DE ALTA FRECUENCIA\n');
fprintf('=========================================================\n');

f_limite = raiz2_newton; 
derivada_local = dg(f_limite); % d|Z|/df
sensibilidad = 1 / derivada_local; % df/d|Z|

fprintf('Frecuencia evaluada:          %.4f Hz\n', f_limite);
fprintf('Derivada local (d|Z|/df):     %.4e Ohm/Hz\n', derivada_local);
fprintf('Sensibilidad inversa (df/d|Z|): %.4f Hz/Ohm\n', sensibilidad);
fprintf('=========================================================\n');