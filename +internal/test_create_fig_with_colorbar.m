close all; clearvars; clc; 

fh = FigureHandler.Create("savePath","+internal\");

x = linspace(0, 2*pi);
y = x.';
z = sin(x).*cos(y);

f = figure("Name","Test Create Fig With Colorbar");
imagesc(x, y, z);
c = colorbar;

xlabel("x");
ylabel("y");
c.Label.String = "c";

fh.PrepareSvg(f);
fh.GenerateOutputs();
