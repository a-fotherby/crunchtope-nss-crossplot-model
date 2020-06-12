path1 = getenv('PATH');
path1 = [path1 ':/usr/local/bin'];
setenv('PATH', path1);

t = tiledlayout(1, 2);
hold on


SALP = [];
exRate =[];
upperBoundArray = [];
lowerBoundArray = [];
SALP_lim = 16;

minSALP = [];

xIsotope = 'SO4--';
yIsotope = 'SO164--';

% Calculate needed back reaction fluxes to get correct percentage recyclings of sulfate.
depthArray = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.2 1.5 1.7 2 2.2 2.5 2.7 3 4 5 7 8 9 10 50 100 250 500];
scaleFactorArray = log10(depthArray/4);


for scaleFactor = scaleFactorArray
    nexttile(1)
    hold on
    
    line21Var = [1 10 15 20 30 40 50 60 70 80 90 100 125 150 175 200 250 300 351] .* 10^scaleFactor;
    line39Var = 0.09077988 * (1 / 10^scaleFactor);
    line40Var = 0.08442012 * (1 / 10^scaleFactor);
    line41Var = 0.08787156 * (1 / 10^scaleFactor);
    line42Var = 0.08732844 * (1 / 10^scaleFactor);
    line43Var = 1E-3 * (1 / 10^scaleFactor);
    line56Var = 0.004 * 10^scaleFactor;
    
    line21Str = sprintf('%g ', line21Var);
    
    editCrunchInput(21, sprintf('spatial_profile %s',  line21Str)); 
    editCrunchInput(39, sprintf('Sulfate_reduction            -rate %g', line39Var));
    editCrunchInput(40, sprintf('Sulfate34_reduction            -rate %g', line40Var));
    editCrunchInput(41, sprintf('Sulfate16_reduction            -rate %g', line41Var));
    editCrunchInput(42, sprintf('Sulfate18_reduction            -rate %g', line42Var));
    editCrunchInput(43, sprintf('16->18EqEx                   -rate %g', line43Var));
    editCrunchInput(56, sprintf('xzones                       1000 %g', line56Var));
    
    scaleFactor

    !~/soft/crunchtope/CrunchTope slaveInput.in
    !~/.scripts/cleanCrunchOutput.sh
    
    [gradient, time] = gradientTimeDepInterp('toperatio_aq', xIsotope, yIsotope, SALP_lim);
    
    normGrad = (gradient ./ gradient(end)) * 100;
    normTime = (time ./ time(end)) * 100;
    
    plot(normTime, normGrad, 'DisplayName', sprintf('%d', line56Var * 1000))
    
    minSALP = [minSALP, min(normGrad)];
end

nexttile(2)
hold on
plot(log(depthArray), log(minSALP), '+')
axis square

nexttile(1)
ylabel('Percetnage progress to steady state SALP')
xlabel('Percentage progress to steady state through time')
ylim([0,300])
legend()
axis square

set(findall(t,'-property','FontSize'),'FontSize',8)

%exportgraphics(t, '/Users/angus/Dropbox/Academic/Isotope Model/Writeup/Figures/gradientPlot.eps', 'ContentType', 'vector');