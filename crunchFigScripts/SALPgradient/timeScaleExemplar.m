time = [0.0001 0.001 0.01 0.1 1 10 100 1000 10000 100000];
SALPerrTime = 0.05 * time;

area(time, SALPerrTime, 'FaceColor', [0.75 0.75 0.75])
hold on
plot(time, SALPerrTime, 'o', 'LineStyle', '-', 'MarkerFaceColor', 'b', 'color', 'b')

xlim(gca, [0.0001 100000])
ylim(gca, [0.000005 50001])

% Create text
text('Parent',gca,'FontSize',12,'String','SALP possibly incorrect',...
    'Position',[6.50675259149003 0.00223416639842909 0]);

% Create text
text('Parent',gca,'FontSize',12,...
    'String',{'Marginal marine','sedimentary','pore fluids'},...
    'Position',[0.0470772492220863 0.306296876367503 0]);

% Create text
text('Parent',gca,'FontSize',12,...
    'String',{'Continental shelf','sedimentary','pore fluids'},...
    'Position',[2.78420154764752 15.6529843600835 0]);

% Create text
text('Parent',gca,'FontSize',12,...
    'String',{'Deep sea','sedimentary','pore fluids'},...
    'Position',[148.083623125781 560.445773763303 0]);

set(gca, 'YScale', 'log');
set(gca, 'Xscale', 'log');
format long g

xlabel('Time scale for a natural system to reach steady state (yrs)')
ylabel('Time when SALP may be incorrect due to transient behaviour (yrs)')

set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(findall(gcf,'-property','Font'),'Font','Helvetica')