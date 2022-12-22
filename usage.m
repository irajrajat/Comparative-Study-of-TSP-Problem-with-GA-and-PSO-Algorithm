
clc;
clear;
close all;

program.citiesNumber = 50;
program.PositionRange = [0 100];

params.MaxIt = 100;
params.nPop  = 20;
params.showPlot = 1;
params.showIters = 1;
% program
% params

out = pso(program, params);
figure;
plot(out.BestCost, 'LineWidth', 2);
%semilogy(out.BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('BestCost');
grid on;