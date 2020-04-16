%% Plot the evolution to steady state of quantity gradients in a single case of the CT model.

path1 = getenv('PATH');
path1 = [path1 ':/usr/local/bin'];
setenv('PATH', path1);

oldFolder = pwd;
cd('~/Dropbox/Academic/Isotope Model/crunchModel/')

for caseNum = 1
    runCommand = sprintf('~/soft/crunchtope/CrunchTope case%d.in', caseNum);
    system(runCommand)
    if caseNum == 3 || caseNum == 4
        restartCommand = sprintf('~/soft/crunchtope/CrunchTope case%dRestart.in', caseNum);
        system(restartCommand)
    end
    !~/.scripts/cleanCrunchOutput.sh
    [SALP, time] = gradientTimeDepInterp('toperatio_aq', 'SO4--', 'SO164--', 16);
    [concGrad, time] = gradientTimeDepInterp('totcon', 'SO4--', 'Distance', 0.01);
    [ScompGrad, time] = gradientTimeDepInterp('toperatio_aq', 'SO4--', 'Distance', 0.01);
    [OcompGrad, time] = gradientTimeDepInterp('toperatio_aq', 'SO164--', 'Distance', 0.01);

    pTimeToSS = time ./ time(end) * 100;
    ppSALP = (SALP ./ SALP(end)) * 100;
    ppScomp = (ScompGrad ./ ScompGrad(end)) * 100;
    ppOcomp = (OcompGrad ./ OcompGrad(end)) * 100;
    ppConc = (concGrad ./ concGrad(end)) * 100;

    
    f = figure;
    hold on;
    
    plot(pTimeToSS, ppSALP, 'DisplayName', 'SALP');
    plot(pTimeToSS, ppConc, 'DisplayName', 'Concentration gradient');
    plot(pTimeToSS, ppScomp, 'DisplayName', 'Sulfur composition gradient');
    plot(pTimeToSS, ppOcomp, 'DisplayName', 'Oxygen composition gradient');
    
    xlabel('Percentage progress to steady state (%)')
    ylabel('Percentage of steady state value (%)')
    ylim([80 200])
    legend
end

set(findall(gcf,'-property','FontSize'),'FontSize',12)

exportgraphics(f, '/Users/angus/Dropbox/Academic/Isotope Model/Writeup/Figures/SALPofTime.eps', 'ContentType', 'vector');

cd(oldFolder)
