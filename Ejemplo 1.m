clc;
clear;
close all;

% Definir variables simbólicas
syms a1 b1 c1 d1 a2 b2 c2 d2 a3 b3 c3 d3

% =========================
% Sistema de ecuaciones
% =========================
eq1  = a1 + b1 + c1 + d1 == 3;

eq2  = 8*a1 + 4*b1 + 2*c1 + d1 == 6;
eq3  = 8*a2 + 4*b2 + 2*c2 + d2 == 6;

eq4  = 27*a2 + 9*b2 + 3*c2 + d2 == 19;
eq5  = 27*a3 + 9*b3 + 3*c3 + d3 == 19;

eq6  = 125*a3 + 25*b3 + 5*c3 + d3 == 99;

eq7  = 12*a1 + 4*b1 + c1 - 12*a2 - 4*b2 - c2 == 0;

eq8  = 27*a2 + 6*b2 + c2 - 27*a3 - 6*b3 - c3 == 0;

eq9  = 12*a1 + 2*b1 - 12*a2 - 2*b2 == 0;

eq10 = 18*a2 + 2*b2 - 18*a3 - 2*b3 == 0;

eq11 = 6*a1 + 2*b1 == 0;

eq12 = 30*a3 + 2*b3 == 0;

% =========================
% Resolver sistema
% =========================
sol = solve([eq1,eq2,eq3,eq4,eq5,eq6,...
             eq7,eq8,eq9,eq10,eq11,eq12],...
             [a1,b1,c1,d1,a2,b2,c2,d2,a3,b3,c3,d3]);

% =========================
% Extraer coeficientes
% =========================
A1 = double(sol.a1);
B1 = double(sol.b1);
C1 = double(sol.c1);
D1 = double(sol.d1);

A2 = double(sol.a2);
B2 = double(sol.b2);
C2 = double(sol.c2);
D2 = double(sol.d2);

A3 = double(sol.a3);
B3 = double(sol.b3);
C3 = double(sol.c3);
D3 = double(sol.d3);

% =========================
% Mostrar resultados
% =========================
disp('Coeficientes encontrados:')

fprintf('f1(x) = %.4fx^3 + %.4fx^2 + %.4fx + %.4f\n',A1,B1,C1,D1)
fprintf('f2(x) = %.4fx^3 + %.4fx^2 + %.4fx + %.4f\n',A2,B2,C2,D2)
fprintf('f3(x) = %.4fx^3 + %.4fx^2 + %.4fx + %.4f\n',A3,B3,C3,D3)

% =========================
% Definir intervalos
% =========================
x1 = linspace(1,2,100);
x2 = linspace(2,3,100);
x3 = linspace(3,5,100);

% =========================
% Evaluar polinomios
% =========================
f1 = A1*x1.^3 + B1*x1.^2 + C1*x1 + D1;

f2 = A2*x2.^3 + B2*x2.^2 + C2*x2 + D2;

f3 = A3*x3.^3 + B3*x3.^2 + C3*x3 + D3;

% =========================
% Graficar
% =========================
figure

plot(x1,f1,'r','LineWidth',2)
hold on

plot(x2,f2,'b','LineWidth',2)

plot(x3,f3,'g','LineWidth',2)

% Puntos conocidos
plot([1 2 3 5],[3 6 19 99],'ko','MarkerFaceColor','k')

grid on

xlabel('x')
ylabel('f(x)')

title('Polinomios por tramos')

legend('f_1(x)','f_2(x)','f_3(x)','Puntos dados')

hold off