clc;
clear all;
close all;

% Abre el archivo para lectura
filename = 'Libro_Ingles.txt'; % Cambia esto por el nombre de tu archivo

fileID = fopen(filename, 'r');

% Lee el contenido del archivo como texto
content = fread(fileID, '*char')';

% Cierra el archivo después de leer
fclose(fileID);

% Reemplaza todos los saltos de línea (\n y \r) con un espacio
content = strrep(content, sprintf('\n'), ' ');  % Reemplaza \n con espacio
content = strrep(content, sprintf('\r'), ' ');  % Reemplaza \r con espacio

% Abre el archivo nuevamente para escritura
fileID = fopen(filename, 'w');

% Escribe el contenido modificado de vuelta en el archivo
fwrite(fileID, content);

% Cierra el archivo
fclose(fileID);

disp('Todos los saltos de línea han sido reemplazados por espacios correctamente.');
