close all; clearvars; clc; 

fh = Create("savePath","tests\");

x = linspace(0, 2*pi, 1000);
y = x; 
z = sin(x.*y);

f = figure("Name", "imagesc test");
imagesc(x, y, z);
xlabel("x");
ylabel("y");
c = colorbar;
ylabel(c, "Color");

fh.PreparePdf(f);
fh.GenerateOutputs();