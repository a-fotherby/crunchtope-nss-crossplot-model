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
text('Parent',gca,'String','Lakes',...
    'Position',[0.000206856041815807 0.000136863662570264 0]);

% Create text
text('Parent',gca,...
    'String',{'Shallowest sedimentary','marine','pore fluids'},...
    'Position',[0.0278420039425285 0.490032029435254 0]);

% Create text
text('Parent',gca,...
    'String',{'Marginal','marine sedimentary','pore fluids'},...
    'Position',[2.09062758533256 28.6410041969284 0]);

% Create text
text('Parent',gca,...
    'String',{'Deep sea','sedimentary','pore fluids'},...
    'Position',[148.083623125781 560.445773763303 0]);
set(gca, 'YScale', 'log');
set(gca, 'Xscale', 'log');
format long g

%curtick = get(gca, 'YTick');
%set(gca, 'YTickLabel', cellstr(num2str(curtick(:))));

%curtick = get(gca, 'XTick');
%set(gca, 'XTickLabel', cellstr(num2str(curtick(:))));

xlabel('Time scale for a natural system to reach steady state (yrs)')
ylabel('Time when SALP may be incorrect due to transient behaviour (yrs)')

set(findall(gcf,'-property','FontSize'),'FontSize',12)