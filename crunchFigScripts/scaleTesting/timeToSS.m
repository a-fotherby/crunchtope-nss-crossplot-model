[SALPttSS, SALPtime] = scaleTesting('toperatio_aq', 'SO4--', 'SO164--', 16);
[SttSS, Stime] = scaleTesting('toperatio_aq', 'SO4--', 'Distance', 'depthProfile');
[OttSS, Otime] = scaleTesting('toperatio_aq', 'SO164--', 'Distance', 'depthProfile');
[concTtSS, concTime] = scaleTesting('totcon', 'SO4--', 'Distance', 'depthProfile');

figure
t = tiledlayout(3,2);

% Remove top empty row from output arrays.
SALPttSS(1, :) = [];
SttSS(1, :) = [];
OttSS(1, :) = [];
concTtSS(1, :) = [];

% Calculate absolute value of gradient.
SALPgrad = abs(gradient(SALPttSS) ./ gradient(SALPtime));
Sgrad = abs(gradient(SttSS) ./ gradient(Stime));
Ograd = abs(gradient(OttSS) ./ gradient(Otime));
concGrad = abs(gradient(concTtSS) ./ gradient(concTime));

% Remove elements from time matrix that correspond to a diff value greater than ssLimit.
ssLimit = 0.03;
SALPtimeMatrix = SALPtime .* (SALPgrad < ssLimit);
StimeMatrix = Stime .* (Sgrad < ssLimit);
OtimeMatrix = Otime .* (Ograd < ssLimit);
concTimeMatrix = concTime .* (concGrad < ssLimit);

SALPequilTimes = nonZeroList(SALPtimeMatrix);
SequilTimes = nonZeroList(StimeMatrix);
OequilTimes = nonZeroList(OtimeMatrix);
concEquilTimes = nonZeroList(concTimeMatrix);

x = categorical({'SALP', 'Sulfate Composition', 'Oxygen Composition', 'Concentration'});
x = reordercats(x,{'SALP', 'Sulfate Composition', 'Oxygen Composition', 'Concentration'});

for caseNum = 1:5
    nexttile()
    yArray = [SALPequilTimes(caseNum) SequilTimes(caseNum) OequilTimes(caseNum) concEquilTimes(caseNum)];
    bar(x, yArray)
end
    