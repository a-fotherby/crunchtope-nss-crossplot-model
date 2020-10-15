path1 = getenv('PATH');
path1 = [path1 ':/usr/local/bin'];
setenv('PATH', path1);

t = tiledlayout(2, 2, 'TileSpacing', 'compact', 'Padding', 'compact');
oldFolder = pwd;
cd('~/Dropbox/Academic/Isotope Model/crunchModel/')

xlabel(t, 'Time (yr)');
ylabel(t, 'SALP');

for caseNum = 1:4
    nexttile()

    runCommand = sprintf('~/soft/crunchtope/CrunchTope case%d.in', caseNum);
    system(runCommand)
    if caseNum == 3 || caseNum == 4
        restartCommand = sprintf('~/soft/crunchtope/CrunchTope case%dRestart.in', caseNum);
        system(restartCommand)
    end
    !~/.scripts/cleanCrunchOutput.sh
    [SALP, time] = gradientTimeDepInterp('toperatio_aq', 'SO4--', 'SO164--', 16);
    
    pTimeToSS = time ./ time(end) * 100;
    scatter(pTimeToSS, SALP, '+');
    title(sprintf('Case %d', caseNum));
end

set(findall(gcf,'-property','FontSize'),'FontSize',12)

%exportgraphics(t, '/Users/angus/Dropbox/Academic/Isotope Model/Writeup/Figures/SALPofTime.eps', 'ContentType', 'vector');

cd(oldFolder)