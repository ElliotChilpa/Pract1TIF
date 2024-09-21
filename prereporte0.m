% MATLAB script para graficar probabilidad y cantidad de información en barras
clc; close all; clear all;

% ABRIR ARCHIVO
archivo=fopen('C:\Users\ellio\OneDrive\Escritorio\UPIITA\Noveno\TeoriaDeLaInformación\Reporte0\principitoe.txt','r');
cadena = fscanf(archivo,'%c'); %guardar archivo en un vector
numcaracteres = length(cadena); %numero de caracteres del archivo
% CIERRE DE ARCHIVO
fclose(archivo);

% Vector con 26 letras del alfabeto español más el espacio
ABC = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',' ', 'ñ'];
ABC0 = zeros(1, length(ABC)); % Vector para conteo de repeticiones de cada letra

% Conteo de repeticiones de cada símbolo
for x = 1:length(ABC)
    rep = 0;
    for y = 1:length(cadena)
        if cadena(y) == ABC(x)
            rep = rep + 1;
        end
    end
    ABC0(x) = rep;
    fprintf('\n%c repeticiones: %d', ABC(x), ABC0(x));
end

% Calcular probabilidades y cantidad de información
p1 = zeros(1, length(ABC0));
I1 = zeros(1, length(ABC0));
for x = 1:length(ABC0)
    p = (ABC0(x) / sum(ABC0)); % Probabilidad
    p1(x) = p;
    I = log2(1 / p); % Cantidad de información por símbolo
    if I == Inf
        I = 0;
    end
    I1(x) = I;
    fprintf('\n%c:\trepeticiones %f\t\tP= %f\t\tI= %f bits \n', ABC(x), ABC0(x), p, I);
end

ABC(ABC == ' ') = '_';

ABC_cell = cellstr(ABC'); % Convertir el arreglo de caracteres a celda
ABC_cat = categorical(ABC_cell); % Convertir a variable categórica


%calculo de la entropia como fuente sin memoria
h=zeros(1,length(p1));
for x=1:length(p1);
    h(x)=p1(x)*I1(x);
end
H=sum(h);
fprintf('\n ENTROPIA COMO FUENTE SIN MEMORIA= %f bits/simbolo\n',H);

% Graficar probabilidad de cada símbolo
figure;
subplot(1,2,1)
bar(ABC_cat, p1, 'Blue');
ylabel('Probabilidad (p)');
xlabel('Símbolo');
title('Probabilidad de cada símbolo, CON Ñ (INGLES)');
%grid on;

% Graficar cantidad de información de cada símbolo
%figure;
subplot(1,2,2)
bar(ABC_cat, I1, 'b');
ylabel('Información (i) en bits');
xlabel('Símbolo');
title('Cantidad de Información por Símbolo, CON Ñ (INGLES)');
%grid on;

%Calculo de la entropia