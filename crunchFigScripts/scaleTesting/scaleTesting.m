7function [pProgressArray, timeArray] = scaleTesting(spatialProfile, species1, species2, SALP_lim)

path1 = getenv('PATH');
path1 = [path1 ':/usr/local/bin'];
setenv('PATH', path1);

t = tiledlayout(3, 2, 'TileSpacing', 'compact', 'Padding', 'compact');
oldFolder = pwd;
cd('~/Dropbox/Academic/Isotope Model/scaleTesting/')

xlabel(t, 'Time (yrs)');
ylabel(t, 'Percentage difference from steady state SALP');

pProgressArray = [];
timeArray = [];
% Check to see if the special SALP limit expression for depth profiles has been specified.
if SALP_lim == 'depthProfile'
    depthSALP_limBool = 1;
else
    depthSALP_limBool = 0;
end

for caseNum = -1:3
    if depthSALP_limBool == 1
        SALP_lim = 0.001 * 10^caseNum;
        if caseNum == -1
            SALP_lim = 0.00025;
        end
    end
    
    nexttile()

    runCommand = sprintf('~/soft/crunchtope/CrunchTope OM%d.in', caseNum);
    system(runCommand)
    !~/.scripts/cleanCrunchOutput.sh
    [SALP, time] = gradientTimeDep(spatialProfile, species1, species2, SALP_lim);
    
    pProgressSALP = 100 * (SALP - SALP(end)) ./ SALP(end);
    
    scatter(time, pProgressSALP, '+');
    title(sprintf('40×10^{%d}cm column', caseNum));
    if caseNum == -1
        title('10 cm column')
    end
    if caseNum == -1
        pProgressArray = zeros(1, length(pProgressSALP));
    end
    pProgressArray = vertcat(pProgressArray, pProgressSALP);
    timeArray = vertcat(timeArray, time);
end

%set(findall(gcf,'-property','FontSize'),'FontSize',12)

%exportgraphics(t, '/Users/angus/Dropbox/Academic/Isotope Model/Writeup/Figures/scaleTesting.eps', 'ContentType', 'vector');

cd(oldFolder)
end

