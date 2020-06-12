%% Plot each case's crossplot with and without advection for comparison.
t = tiledlayout(2,4, 'TileSpacing', 'compact', 'Padding', 'compact');

for caseNum = [1 2 3 4]
    nexttile(caseNum);
    directory = sprintf('~/Dropbox/Academic/Isotope Model/crunchModel/crunchData/case%d', caseNum);
    cd(directory);
    isotopeCrossplot('SO4--', 'SO164--');
    caseLabel = sprintf('Case %d', caseNum);
    title(gca, caseLabel, 'FontWeight', 'bold')
    xlabel(gca, '\delta^{34}S')
    ylabel(gca, '\delta^{18}O')
    xlim(gca, [20 120])
    ylim(gca, [8 22])
    axis square;
    if caseNum == 1
        ylabel(gca, {'No advection' '\delta^{18}O'});
    end
    
    nexttile(caseNum + 4);
    directory = sprintf('~/Dropbox/Academic/Isotope Model/crunchModel/crunchData/case%dAdv', caseNum);
    cd(directory);
    isotopeCrossplot('SO4--', 'SO164--');
    xlabel(gca, '\delta^{34}S')
    ylabel(gca, '\delta^{18}O')
    xlim(gca, [20 120])
    ylim(gca, [8 22])
    axis square;
    if caseNum == 1
        ylabel(gca, {'Advection = 50m/myr' '\delta^{18}O'});
    end
end

set(findall(gcf,'-property','FontSize'),'FontSize',12)