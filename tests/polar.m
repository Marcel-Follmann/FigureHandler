close all; clearvars; clc; 

fh = Create("savePath","tests\");

theta = linspace(0,2*pi,1000);
r = sin(theta)+1;

f = figure("Name","Polar");
polarplot(theta, r); hold on; 
polarplot(theta, 2*r);

fh.PrepareSvg(f);
fh.GenerateOutputs();