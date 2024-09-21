clc; 
close all; 
clear all;

%**************************************************************************
%                    ABRIR Y LEER EL ARCHIVO DE TEXTO
%**************************************************************************

% Abrir el archivo de texto
archivo = fopen('C:\Users\ellio\OneDrive\Escritorio\UPIITA\Noveno\TeoriaDeLaInformación\Reporte0\principitoe.txt', 'r');
cadena = fscanf(archivo, '%c'); % Guardar el contenido del archivo en un vector de caracteres
numcaracteres = length(cadena);  % Contar el número total de caracteres del archivo
fclose(archivo); % Cerrar el archivo

%**************************************************************************
%                    ANÁLISIS DE ENTROPÍA SIN MEMORIA (FUENTE SIMPLE)
%**************************************************************************

% Definir el alfabeto (incluye el espacio)
ABC = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','ñ','o','p','q','r','s','t','u','v','w','x','y','z',' '];

% Inicializar el vector para contar las repeticiones de cada letra
ABC0 = zeros(1, length(ABC));

% Contar las repeticiones de cada letra en la cadena
for x = 1:length(ABC)
    rep = 0; % Variable temporal para contar repeticiones de la letra actual
    for y = 1:length(cadena)
        if cadena(y) == ABC(x)
            rep = rep + 1;
        end
    end
    ABC0(x) = rep; % Guardar el número de repeticiones en el vector
end

% Inicializar vectores para probabilidades y cantidades de información
p1 = zeros(1, length(ABC0)); 
I1 = zeros(1, length(ABC0));

% Calcular probabilidades y cantidades de información por carácter
for x = 1:length(ABC0)
    p = (ABC0(x) / sum(ABC0)); % Probabilidad de cada carácter
    p1(x) = p;
    
    I = log2(1 / p); % Cantidad de información por carácter
    
    if I == Inf % Si la probabilidad es 0, la cantidad de información es infinita
        I = 0;  % Se ajusta para evitar que invalide el cálculo de la entropía
    end
    I1(x) = I;
end

% Calcular la entropía como fuente sin memoria
h = zeros(1, length(p1));
for x = 1:length(p1)
    h(x) = p1(x) * I1(x); % Multiplicar probabilidad por cantidad de información
end
H = sum(h); % Entropía total
fprintf('\nESPAÑOL: ENTROPIA COMO FUENTE SIN MEMORIA= %f  \n', H);

%**************************************************************************
%                    ANÁLISIS PARA PAREJAS DE CARACTERES
%**************************************************************************

% Inicializar matriz para contar repeticiones de pares de caracteres
cont2 = zeros(length(ABC), length(ABC));

% Contar las repeticiones de cada pareja de letras consecutivas
for x = 1:length(ABC)
    for y = 1:length(ABC)
        cont = 0; % Contador temporal para parejas
        for z = 1:(length(cadena) - 1)
            if cadena(z) == ABC(x) && cadena(z + 1) == ABC(y)
                cont = cont + 1;
            end
        end
        cont2(x, y) = cont; % Guardar el conteo en la matriz
    end
end

% Inicializar vectores para probabilidades y cantidades de información de pares
pares = reshape(cont2, 1, []); % Convertir la matriz en un vector
p2 = zeros(1, length(pares));
I2 = zeros(1, length(pares));

% Calcular probabilidades y cantidades de información para pares
for x = 1:length(pares)
    p = (pares(x) / sum(pares)); % Probabilidad de cada pareja
    p2(x) = p;
    
    I = log2(1 / p); % Cantidad de información por pareja
    
    if I == Inf
        I = 0;
    end
    I2(x) = I;
end

%**************************************************************************
%                    ANÁLISIS PARA TRÍOS DE CARACTERES
%**************************************************************************

% Inicializar matriz tridimensional para contar tríos de caracteres
cont3 = zeros(length(ABC), length(ABC), length(ABC));

% Contar las repeticiones de cada trío consecutivo de letras
for x = 1:length(ABC)
    for y = 1:length(ABC)
        for z = 1:length(ABC)
            cont = 0;
            for a = 1:(length(cadena) - 2)
                if cadena(a) == ABC(x) && cadena(a + 1) == ABC(y) && cadena(a + 2) == ABC(z)
                    cont = cont + 1;
                end
            end
            cont3(x, y, z) = cont; % Guardar el conteo en la matriz tridimensional
        end
    end
end

% Inicializar vectores para probabilidades y cantidades de información de tríos
tercias = reshape(cont3, 1, []); % Convertir la matriz tridimensional en un vector
p3 = zeros(1, length(tercias));
I3 = zeros(1, length(tercias));

% Calcular probabilidades y cantidades de información para tríos
for x = 1:length(tercias)
    p = (tercias(x) / sum(tercias)); % Probabilidad de cada trío
    p3(x) = p;
    
    I = log2(1 / p); % Cantidad de información por trío
    
    if I == Inf
        I = 0;
    end
    I3(x) = I;
end

%**************************************************************************
%                    CÁLCULO DE ENTROPÍA CON MEMORIA (MARKOV 1er ORDEN)
%**************************************************************************

% Inicializar matriz de probabilidades condicionales para pares
pc1 = zeros(length(ABC), length(ABC));

% Calcular probabilidades condicionales de cada par (Markov de primer orden)
for x = 1:length(ABC)
    for y = 1:length(ABC)
        if ABC0(y) == 0
            pc1(x, y) = 0;
        else
            pc1(x, y) = cont2(x, y) / ABC0(y);
        end
    end
end

% Calcular entropía con memoria de Markov de primer orden
marcov1 = 0;
for x = 1:length(ABC)
    for y = 1:length(ABC)
        if pc1(x, y) ~= 0
            marcov1 = marcov1 + (p1(y) * pc1(x, y) * log2(1 / pc1(x, y)));
        end
    end
end
fprintf('\nESPAÑOL: ENTROPIA COMO FUENTE CON MEMORIA MARKOV 1°= %f  \n', marcov1);

%**************************************************************************
%                    CÁLCULO DE ENTROPÍA CON MEMORIA (MARKOV 2do ORDEN)
%**************************************************************************

% Inicializar matriz tridimensional para probabilidades condicionales de tríos
pc2 = zeros(length(ABC), length(ABC), length(ABC));

% Calcular probabilidades condicionales de cada trío (Markov de segundo orden)
for x = 1:length(ABC)
    for y = 1:length(ABC)
        for z = 1:length(ABC)
            if cont3(x, y, z) == 0
                pc2(x, y, z) = 0;
            else
                pc2(x, y, z) = cont3(x, y, z) / cont2(y, z);
            end
        end
    end
end

% Calcular entropía con memoria de Markov de segundo orden
marcov2 = 0;
for x = 1:length(ABC)
    for y = 1:length(ABC)
        for z = 1:length(ABC)
            if pc2(x, y, z) ~= 0
                marcov2 = marcov2 + (p1(z) * pc1(y, z) * pc2(x, y, z) * log2(1 / pc2(x, y, z)));
            end
        end
    end
end
fprintf('\nESPAÑOL: ENTROPIA COMO FUENTE CON MEMORIA MARKOV 2°= %f  \n\n', marcov2);

%**************************************************************************
%                    VISUALIZACIÓN DE RESULTADOS
%**************************************************************************

% Crear una gráfica de barras para mostrar las entropías calculadas
figure(1)
hs = [H, marcov1, marcov2];
bar(hs, 'm')
title('Entropía Fuente Sin Memoria vs Markov 1° y 2° Orden')
xlabel('Modelo')
ylabel('Entropía')
set(gca, 'XTickLabel', {'Sin Memoria', 'Markov 1° Orden', 'Markov 2° Orden'})
