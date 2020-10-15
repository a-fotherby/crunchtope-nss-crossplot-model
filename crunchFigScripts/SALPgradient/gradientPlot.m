%In this usecase, the linenumber we wish to change is always 45.

t=tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

nexttile()
timeScaleExemplar
axis square

path1 = getenv('PATH');
path1 = [path1 ':/usr/local/bin'];
setenv('PATH', path1);

SALP = [];
exRate =[];
upperBoundArray = [];
lowerBoundArray = [];
SALP_lim = 16;

xIsotope = 'SO4--';
yIsotope = 'SO164--';

% Calculate needed back reaction fluxes to get correct percentage recyclings of sulfate.
R_t = 0.1752;
percRArray = [0:5:95]; 
rArray = (percRArray / 100) ./ (1 - (percRArray/100));
% Equation 24 using values from case 1 input files.
exArray = rArray * 0.08787460815 / (1 + (50/0.1023565));

alpha34 = 0.975 - (0.05 * (percRArray/100));
k32 = 0.1752 ./ (1 + alpha34);
k34 = 0.1752 - k32;

for i=1:length(exArray)
    editCrunchInput(43, sprintf('16->18EqEx -rate %d', exArray(i)));
    editCrunchInput(39, sprintf('Sulfate_reduction -rate %d', k32(i)));
    editCrunchInput(40, sprintf('Sulfate34_reduction -rate %d', k34(i)));

    !~/soft/crunchtope/CrunchTope slaveInput.in
    !~/.scripts/cleanCrunchOutput.sh
    
    [gradient, time] = gradientTimeDepInterp('toperatio_aq', xIsotope, yIsotope);
    [upper, lower] = SALPerrorBars(gradient, time);
    
    SALP = horzcat(SALP, gradient(1, end));
    upperBoundArray = horzcat(upperBoundArray, upper);
    lowerBoundArray = horzcat(lowerBoundArray, lower);
end

upperErrorBar = upperBoundArray - SALP; 
lowerErrorBar = SALP - lowerBoundArray;

nexttile()

errorbar(percRArray, SALP, lowerErrorBar, upperErrorBar, '+')
ylabel('SALP')
xlabel('Percentage sulfate recycled')

axis square

set(findall(t,'-property','FontSize'),'FontSize',8)

% So apparently to get the desired effect here,
% you have the XTick code outside the script and called here.
% MatLab is a truly mysterious mistress. 
nexttile(1)
curtick = get(gca, 'YTick');
set(gca, 'YTickLabel', cellstr(num2str(curtick(:))));
curtick = get(gca, 'XTick');
set(gca, 'XTickLabel', cellstr(num2str(curtick(:))));

set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','Font'),'Font','Helvetica')

%exportgraphics(t, '/Users/angus/Dropbox/Academic/Isotope Model/Writeup/Figures/gradientPlot.eps', 'ContentType', 'vector');