close all; clearvars; clc; 

fh = FigureHandler.Create("savePath","+internal\");

x = linspace(0, 2*pi, 1000);
y = cos(x);

f = figure("Name", "Test Create SVG");
plot(x, y); 

fh.PrepareSvg(f);
fh.GenerateOutputs();