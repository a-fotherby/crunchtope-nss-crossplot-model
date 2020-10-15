%% Plot the evolution to steady state of quantity gradients in a single case of the CT model.

t = tiledlayout(1,4);

path1 = getenv('PATH');
path1 = [path1 ':/usr/local/bin'];
setenv('PATH', path1);

oldFolder = pwd;
cd('~/Dropbox/Academic/Isotope Model/crunchModel/')

for caseNum = [1:4]
    nexttile()

    runCommand = sprintf('~/soft/crunchtope/CrunchTope case%d.in', caseNum);
    system(runCommand)
    if caseNum == 3 || caseNum == 4
        restartCommand = sprintf('~/soft/crunchtope/CrunchTope case%dRestart.in', caseNum);
        system(restartCommand)
    end
    !~/.scripts/cleanCrunchOutput.sh
    
    concMap = importSpatialProfile('totcon');
    
    % plotVar must be a string.
    keyArray = keys(concMap);
    valuesArray = values(concMap, keyArray);

    maxTimeIndex = size(valuesArray, 2);
    cmap = colormap(jet(maxTimeIndex));
    
    initialTable = valuesArray{1};
    finalTable = valuesArray{maxTimeIndex};

    initialArray = initialTable.('SO4--') + initialTable.('S34O4--');
    finalArray = finalTable.('SO4--') + finalTable.('S34O4--');
    
    for timeIndex = 1 : (maxTimeIndex)
        
        speciesArray = valuesArray{timeIndex};
        pProgress = getpProgress(speciesArray.('SO4--') + speciesArray.('S34O4--'), finalArray, initialArray);
        
        plot((speciesArray.('SO4--') + speciesArray.('S34O4--')) * 1000, speciesArray.Distance, 'DisplayName', sprintf('%.0f%%', pProgress), 'color', cmap(timeIndex, :))
        %plot(speciesArray.('SO4--') + speciesArray.('S34O4--'), speciesArray.Distance, 'DisplayName', sprintf('%d', pProgress), 'color', cmap(timeIndex, :))
        units = speciesArray.Properties.VariableUnits{'SO4--'};
        xlabel('SO_4^{2+} (mM)');
        ylabel('Depth (m)');
        title(sprintf('Case %d', caseNum));
        hold on
    end
    set(gca,'FontSize',18);
    set(gca,'Ydir','reverse');
    pbaspect([1 2 1]) 
end

set(findall(gcf,'-property','FontSize'),'FontSize',12)

%exportgraphics(f, '/Users/angus/Dropbox/Academic/Isotope Model/Writeup/Figures/SALPofTime.eps', 'ContentType', 'vector');

cd(oldFolder)