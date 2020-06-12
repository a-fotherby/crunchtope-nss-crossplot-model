%% Plot the evolution to steady state of quantity gradients in a single case of the CT model.

t = tiledlayout(2,4);

path1 = getenv('PATH');
path1 = [path1 ':/usr/local/bin'];
setenv('PATH', path1);

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
    axis square
    
    nexttile(caseNum + 4)

    runCommand = sprintf('~/soft/crunchtope/CrunchTope noRcase%d.in', caseNum);
    system(runCommand)
    if caseNum == 3 || caseNum == 4
        restartCommand = sprintf('~/soft/crunchtope/CrunchTope noRcase%dRestart.in', caseNum);
        system(restartCommand)
    end
    !~/.scripts/cleanCrunchOutput.sh
    
    isotopeCrossplot('SO4--', 'SO164--')
    axis square
end

%exportgraphics(f, '/Users/angus/Dropbox/Academic/Isotope Model/Writeup/Figures/SALPofTime.eps', 'ContentType', 'vector');

cd(oldFolder)