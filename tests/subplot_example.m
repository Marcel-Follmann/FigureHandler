close all; clearvars; clc; 

fh = Svg("savePath","FigureHandler\tests");

x = linspace(0, 2*pi, 1000);
y1 = sin(x);
y2 = cos(x);

f = figure("Name", "Test Subplots 1");
t = tiledlayout(1, 2);
ax1 = nexttile; 
plot(x, y1);
xlabel("Time (s)");
ylabel("Amplitude (-)");
ax2 = nexttile; 
plot(x, y2);
xlabel("Time (s)");
ylabel("Amplitude (-)");
% cb = colorbar;
% cb.Layout.Tile = "north";
% xlabel(cb, "Magnitude (dB)");

% f = figure("Name", "Test Subplots 2");
% t = tiledlayout(1, 2);
% ax1 = nexttile; 
% plot(x, y1);
% xlabel("Time (s)");
% ylabel("Amplitude (-)");
% ax2 = nexttile; 
% plot(x, y2);
% xlabel("Time (s)");
% ylabel("Amplitude (-)");
% cb = colorbar;
% cb.Layout.Tile = "east";
% xlabel(cb, "Magnitude (dB)");

fh.Prepare(f);
fh.GenerateOutputs();