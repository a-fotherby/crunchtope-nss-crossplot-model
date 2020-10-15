%% Plot each case's crossplot with and without advection for comparison.
t = tiledlayout(2,4)
oldFolder = pwd;
cd('~/Dropbox/Academic/Isotope Model/crunchModel/')

for caseNum = [1:4]
    nexttile(caseNum)

    runCommand = sprintf('~/soft/crunchtope/CrunchTope case%d.in', caseNum);
    system(runCommand)
    if caseNum == 3 || caseNum == 4
        restartCommand = sprintf('~/soft/crunchtope/CrunchTope case%dRestart.in', caseNum);
        system(restartCommand)
    end
    !~/.scripts/cleanCrunchOutput.sh
    
    isotopeCrossplot('SO4--', 'SO164--')
    xlabel('\delta^{34}S (‰)')
    ylabel('\delta^{18}O (‰)')
    xlim([20, 80])
    ylim([8, 22])

    axis square
    
    nexttile(caseNum + 4)

    runCommand = sprintf('~/soft/crunchtope/CrunchTope advcase%d.in', caseNum);
    system(runCommand)
    if caseNum == 3 || caseNum == 4
        restartCommand = sprintf('~/soft/crunchtope/CrunchTope advcase%dRestart.in', caseNum);
        system(restartCommand)
    end
    !~/.scripts/cleanCrunchOutput.sh
    
    isotopeCrossplot('SO4--', 'SO164--')
    xlabel('\delta^{34}S (‰)')
    ylabel('\delta^{18}O (‰)')
    xlim([20, 80])
    ylim([8, 22])

    axis square
end