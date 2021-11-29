clear; 
mice = {'zz054','zz062','zz063','zz066','zz067','zz068','zz069'};

rootPath = 'C:\Users\zzhu34\Documents\tempdata\octoData\';
loadPath = [rootPath filesep 'trialData\'];

for i = 1:length(mice)
    load([loadPath mice{i} '.mat']);
    tempObj{i} = wheel2AFC(trialData);
end

%%
mouseMega = wheel2AFCmega(tempObj);

%% REINF PLOT
trialLim = 3000;
trialBin = 0:250:trialLim;
trialBinPlot = (trialBin(1:end-1) + trialBin(2:end))/2;

binProbe = nan(length(trialBin)-1,size(mouseMega.probe.probe,2));
binProbeBias = nan(length(trialBin)-1,size(mouseMega.probe.probe,2));
for i = 1:size(mouseMega.probe.probe,2)
    trialNum = mouseMega.probe.trialNum(:,i);
    trialLimFlag = trialNum>trialLim | isnan(trialNum); trialNum(trialLimFlag) = [];
    
    binIdx = sum(trialNum>trialBin,2);
    binProbe(binIdx,i) = mouseMega.probe.probe(~trialLimFlag,i);
    binProbeBias(binIdx,i) = mouseMega.probe.probeBias(~trialLimFlag,i);
    
end

nData = sum(~isnan(binProbe),1); nData(nData==0) = nan;
meanBinProbe = nanmean(binProbe,2); nanflag = isnan(meanBinProbe);
semProbePerf = nanstd(binProbe,0,2)./sqrt(nData);
meanBinProbeBias = nanmean(abs(binProbeBias),2); 
semBinProbeBias = nanstd(abs(binProbeBias),0,2)./sqrt(nData);

accuracy = mouseMega.accuracy;
bias = abs(mouseMega.bias);
%% --------------------------------PLOT 1.1 REINF-PROBE PERF SEM-------------------------------------
fn_figureSmartDim('hSize',0.25,'widthHeightRatio',1.8); hold on;
f_errorbar = fn_plotFillErrorbar(trialBinPlot(~nanflag),meanBinProbe(~nanflag),semProbePerf(~nanflag),...
    matlabColors(2),'faceAlpha',0.2,'LineStyle','none');
f_errorbar = fn_plotFillErrorbar(1:size(mouseMega.accuracy,1),(nanmean(mouseMega.accuracy,2))',...
    (nanstd(mouseMega.accuracy,0,2)./sqrt(size(mouseMega.accuracy,2)))',...
    matlabColors(1),'faceAlpha',0.2,'LineStyle','none');
plot(nanmean(mouseMega.accuracy,2),'Color', matlabColors(1,0.9), 'LineWidth',2);
plot(trialBinPlot(~nanflag),meanBinProbe(~nanflag),'--o','Color',matlabColors(2,0.9),'LineWidth',2)
plot([1 trialLim],[0.5 0.5],'Color',[0.6 0.6 0.6],'LineWidth',2);
xlim([1 trialLim]); ylabel('Accuracy'); xlabel('Trials');

%% ----------------------------PLOT 1.2 REINF-PROBE PERF INDIVIDUAL ANIMAL-------------------------------
fn_figureSmartDim('hSize',0.25,'widthHeightRatio',1.8); hold on;
% PLOT REINF
for j = 1:size(mouseMega.accuracy,2)
    plot(mouseMega.accuracy(:,j),'Color', matlabColors(1,0.2), 'LineWidth',1);
end
for j = 1:size(binProbe,2)
    plot(trialBinPlot,binProbe(:,j),'--o','Color', matlabColors(2,0.4), 'LineWidth',1)
end
plot(nanmean(mouseMega.accuracy,2),'Color', matlabColors(1,0.9), 'LineWidth',2);
% PLOT PROBE AGAIN
plot(trialBinPlot(~nanflag),meanBinProbe(~nanflag),'--o','Color',matlabColors(2,0.9),'LineWidth',2)
plot([1 trialLim],[0.5 0.5],'Color',[0.6 0.6 0.6],'LineWidth',2);
xlim([1 trialLim]); ylabel('Accuracy'); xlabel('Trials');

%% -----------------------------PLOT 1.3 REINF PERF INDIVIDUAL ANIMAL-----------------------------------
fn_figureSmartDim('hSize',0.25,'widthHeightRatio',1.8); hold on;
% PLOT REINF
for j = 1:size(mouseMega.accuracy,2)
    plot(mouseMega.accuracy(:,j),'Color', matlabColors(1,0.2), 'LineWidth',1);
end
plot(nanmean(mouseMega.accuracy,2),'Color', matlabColors(1,0.9), 'LineWidth',2);
plot([1 trialLim],[0.5 0.5],'Color',[0.6 0.6 0.6],'LineWidth',2);
xlim([1 trialLim]); ylabel('Accuracy'); xlabel('Trials');

%% -----------------------REINF BEF AFT WITH PROBE--------------------------
nDay = 7;

figure; subplot(1,2,1); hold on;
tempBefFlat = reshape(mouseMega.probe.reinfBef(1:nDay,:),1,[]);
tempAftFlat = reshape(mouseMega.probe.reinfAft(1:nDay,:),1,[]);
tempProbeFlat = reshape(mouseMega.probe.probe(1:nDay,:),1,[]);
nanFlag = isnan(tempProbeFlat); 
tempBefFlat(nanFlag) = []; tempAftFlat(nanFlag) = []; tempProbeFlat(nanFlag) = [];
[hBef,pBef] = ttest(tempBefFlat,tempProbeFlat,'tail','left');
[hAft,pAft] = ttest(tempAftFlat,tempProbeFlat,'tail','left');
bar([nanmean(tempBefFlat) nanmean(tempProbeFlat) nanmean(tempAftFlat)] ,'EdgeColor','None','FaceColor',matlabColors(2,0.9)); hold on;
for i = 1:length(tempBefFlat)
    f = plot([1 2 3],[tempBefFlat(i) tempProbeFlat(i) tempAftFlat(i)],'Color',[0.6 0.6 0.6],'Marker','.','MarkerSize',15,...
        'MarkerFaceColor',[0.6 0.6 0.6],'LineWidth',0.5);
end
legend(f,['pBef = ' num2str(pBef,'%.2e') newline 'pAft = ' num2str(pAft,'%.2e')],'Location','Best')
ylabel('Accuracy'); xticks([1 2 3]); xticklabels({'Bef','Probe','Aft'}); xlim([0 4]);

subplot(1,2,2); hold on;
tempBefFlat = abs(reshape(mouseMega.probe.reinfBefBias(1:nDay,:),1,[]));
tempAftFlat = abs(reshape(mouseMega.probe.reinfAftBias(1:nDay,:),1,[]));
tempProbeFlat = abs(reshape(mouseMega.probe.probeBias(1:nDay,:),1,[]));
nanFlag = isnan(tempProbeFlat); 
tempBefFlat(nanFlag) = []; tempAftFlat(nanFlag) = []; tempProbeFlat(nanFlag) = [];
[hBef,pBef] = ttest(tempBefFlat,tempProbeFlat,'tail','right');
[hAft,pAft] = ttest(tempAftFlat,tempProbeFlat,'tail','right');
bar([nanmean(tempBefFlat) nanmean(tempProbeFlat) nanmean(tempAftFlat)] ,'EdgeColor','None','FaceColor',matlabColors(2,0.9)); hold on;
for i = 1:length(tempBefFlat)
    f = plot([1 2 3],[tempBefFlat(i) tempProbeFlat(i) tempAftFlat(i)],'Color',[0.6 0.6 0.6],'Marker','.','MarkerSize',15,...
        'MarkerFaceColor',[0.6 0.6 0.6],'LineWidth',0.5);
end
legend(f,['pBef = ' num2str(pBef,'%.2e') newline 'pAft = ' num2str(pAft,'%.2e')],'Location','Best')
ylabel('Bias(Abs)'); xticks([1 2 3]); xticklabels({'Bef','Probe','Aft'}); xlim([0 4]);

%% ------------------------------Bias-------------------------------

% REINF ONLY
fn_figureSmartDim('hSize',0.25,'widthHeightRatio',1.8); hold on;
for j = 1:size(bias,2)
    plot(bias(:,j),'Color', matlabColors(1,0.2), 'LineWidth',1);
end
plot(nanmean(bias,2),'Color', matlabColors(1,0.9), 'LineWidth',2);
xlim([1 trialLim]); ylim([0 1]); ylabel('Bias'); xlabel('Trials');
% REINF AND PROBE
fn_figureSmartDim('hSize',0.25,'widthHeightRatio',1.8); hold on;
plot(nanmean(bias,2),'Color', matlabColors(1,0.9), 'LineWidth',2);
f_errorbar = fn_plotFillErrorbar(1:size(bias,1),(nanmean(bias,2))',...
    (nanstd(bias,0,2)./sqrt(size(bias,2)))',...
    matlabColors(1),'faceAlpha',0.2,'LineStyle','none');
f_errorbar = fn_plotFillErrorbar(trialBinPlot(~nanflag),meanBinProbeBias(~nanflag),semBinProbeBias(~nanflag),...
    matlabColors(2),'faceAlpha',0.2,'LineStyle','none');
plot(trialBinPlot(~nanflag),meanBinProbeBias(~nanflag),'--o','Color',matlabColors(2,0.9),'LineWidth',2)
xlim([1 trialLim]); ylim([0 1]); ylabel('Bias'); xlabel('Trials');

%% ---------------------PLOT ACCURACY AND BIAS TOGETHER----------------------
fn_figureSmartDim('hSize',0.3,'widthHeightRatio',1) ; hold on; 
avgAccSmooth = smoothdata(nanmean(accuracy,2),'movmean',200);
avgBiasSmooth = smoothdata(nanmean(bias,2),'movmean',200);
for i = 1:size(accuracy,2)
    accSmooth = smoothdata(accuracy(:,i),'movmean',400); biasSmooth = smoothdata(bias(:,i),'movmean',400);
    plot(accSmooth,biasSmooth,'Color',matlabColors(i,0.3));
    plot(accSmooth(1),biasSmooth(1),'.','MarkerSize',15,'Color',matlabColors(i))
    plot(accSmooth(end),biasSmooth(end),'*','MarkerSize',8,'Color',matlabColors(i))
end
plot(avgAccSmooth,avgBiasSmooth,'Color',[0 0 0],'LineWidth',2);
xlim([0.3 0.95]); xticks([0.3 0.5 0.7 0.9])
xlabel('Accuracy'); ylabel('Action Bias')

%% ------------------------------REACTION TIME-------------------------------
reactionTime = mouseMega.reactionTime;
reactionTime(reactionTime > 2.6) = nan; reactionTime(reactionTime < 0) = nan;
reactionTime = smoothdata(reactionTime,1,'movmean',50,'includenan');

fn_figureSmartDim('hSize',0.25,'widthHeightRatio',1.8); hold on;
for j = 1:size(reactionTime,2)
    plot(reactionTime(:,j),'Color', matlabColors(1,0.2), 'LineWidth',1);
end
plot(nanmean(reactionTime,2),'Color', matlabColors(1,0.9), 'LineWidth',2);
ylim([0.3 1.5]); xlim([1 trialLim]);
ylabel('nMovements'); xlabel('Trials');

%% ------------------------------ITI MOVEMENTS-------------------------------
wheelPreSound = mouseMega.wheel.wheelPreSound;
wheelPreSound = smoothdata(wheelPreSound,1,'movmean',50,'includenan');
%wheelPreSound = wheelPreSound./repmat(nanmean(wheelPreSound(1:500,:),1),trialLim,1); %normalize to the first day of each animal
fn_figureSmartDim('hSize',0.25,'widthHeightRatio',1.8); hold on;
for j = 1:size(accuracy,2)
    plot(wheelPreSound(:,j),'Color', matlabColors(1,0.2), 'LineWidth',1);
end
plot(nanmean(wheelPreSound,2),'Color', matlabColors(1,0.9), 'LineWidth',2);
xlim([1 trialLim]);
ylabel('Reaction Time (s)'); xlabel('Trials');
