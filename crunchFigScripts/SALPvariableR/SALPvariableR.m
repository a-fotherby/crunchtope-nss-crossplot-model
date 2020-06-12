%In this usecase, the linenumber we wish to change is always 45.

t=tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

path1 = getenv('PATH');
path1 = [path1 ':/usr/local/bin'];
setenv('PATH', path1);

SALP = [];
exRate =[];
upperBoundArray = [];
lowerBoundArray = [];

xIsotope = 'SO4--';
yIsotope = 'SO164--';

% Calculate needed back reaction fluxes to get correct percentage recyclings of sulfate.
R_t = 0.1752;
percRArray = [0 50 95 99]; 
rArray = (percRArray / 100) ./ (1 - (percRArray/100));
% Equation 24 using values from case 1 input files.
exArray = rArray * 2 * 0.08787460815 / (1 + (50/0.1023565));

alpha34 = 0.975 - (0.05 * (percRArray/100));
k32 = 0.1752 ./ (1 + alpha34);
k34 = 0.1752 - k32;

for i=1:length(exArray)
    editCrunchInput(43, sprintf('16->18EqEx -rate %d', exArray(i)));
    editCrunchInput(39, sprintf('Sulfate_reduction -rate %d', k32(i)));
    editCrunchInput(40, sprintf('Sulfate34_reduction -rate %d', k34(i)));

    !~/soft/crunchtope/CrunchTope slaveInput.in
    !~/.scripts/cleanCrunchOutput.sh
    
    isotopeCrossplot('SO4--', 'SO164--')
    hold on
end