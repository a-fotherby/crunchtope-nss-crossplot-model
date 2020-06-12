% Plot SALP equilibreum value against column depth.

path1 = getenv('PATH');
path1 = [path1 ':/usr/local/bin'];
setenv('PATH', path1);

f = figure();
hold on

xIsotope = 'SO4--';
yIsotope = 'SO164--';

% Calculate needed back reaction fluxes to get correct percentage recyclings of sulfate.

R_t = [0.01752 0.1752];
scaleFactor = [1 0];


for i = [1:2]
    
    line21Var = [0.001 7 15 23 34 46 61 81 108 155 900] .* 10^scaleFactor(i);

    r = 14;
    gamma = r / (r+1);
    % Equation 24 using values from case 1 input files.

    alpha34 = 0.975 - (0.05 * (gamma));
    alpha16 = 0.99375;
    k16 = (1 / (1 + alpha16)) * R_t(i);
    k18 = (alpha16 / (1 + alpha16)) * R_t(i);

    k32 = R_t(i) ./ (1 + alpha34);
    k34 = R_t(i) - k32;
    kex = r * 2 * k16 / (1 + (50/0.1023565));
        
    line21Str = sprintf('%g ', line21Var);
    
    editCrunchInput(21, sprintf('spatial_profile %s',  line21Str)); 
    editCrunchInput(39, sprintf('Sulfate_reduction            -rate %g', k16));
    editCrunchInput(40, sprintf('Sulfate34_reduction            -rate %g', k18));
    editCrunchInput(41, sprintf('Sulfate16_reduction            -rate %g', k32));
    editCrunchInput(42, sprintf('Sulfate18_reduction            -rate %g', k34));
    editCrunchInput(43, sprintf('16->18EqEx                   -rate %g', kex));
    
    !~/soft/crunchtope/CrunchTope slaveInput.in
    !~/.scripts/cleanCrunchOutput.sh
    
    [gradient, time] = gradientTimeDepInterp('toperatio_aq', xIsotope, yIsotope);
     
    scatter(log10(line56Var * 1000), gradient(end))
    
end

ylabel('Equilibrium SALP')
xlabel('Log10(depth)')
legend()

set(findall(t,'-property','FontSize'),'FontSize',16)

%exportgraphics(t, '/Users/angus/Dropbox/Academic/Isotope Model/Writeup/Figures/gradientPlot.eps', 'ContentType', 'vector');