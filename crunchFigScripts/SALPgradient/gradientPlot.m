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
recArray = [0:5:95]; 
bArray = (recArray * R_t) ./ (100 - recArray);

for exchangeRate = bArray
    editCrunchInput(43, exchangeRate);
    !~/soft/crunchtope/CrunchTope slaveInput.in
    !~/.scripts/cleanCrunchOutput.sh
    
    [gradient, time] = gradientTimeDepInterp('toperatio_aq', xIsotope, yIsotope, SALP_lim);
    [upper, lower] = SALPerrorBars(gradient, time);
    
    SALP = horzcat(SALP, gradient(1, end));
    exRate = horzcat(exRate, exchangeRate);
    percentRec = (exRate ./ (exRate + R_t) ) * 100;
    upperBoundArray = horzcat(upperBoundArray, upper);
    lowerBoundArray = horzcat(lowerBoundArray, lower);
end

upperErrorBar = upperBoundArray - SALP; 
lowerErrorBar = SALP - lowerBoundArray;

nexttile()

errorbar(percentRec, SALP, lowerErrorBar, upperErrorBar, '+')
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

exportgraphics(t, '/Users/angus/Dropbox/Academic/Isotope Model/Writeup/Figures/gradientPlot.eps', 'ContentType', 'vector');