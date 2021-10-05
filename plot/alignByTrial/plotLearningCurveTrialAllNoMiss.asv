function plotLearningCurveTrialAllNoMiss(mice)

if nargin == 1; selectProtocol = {'puretone'}; end
global sep;

rootPath = 'C:\Users\zzhu34\Documents\tempdata\octoData\';
loadPath = [rootPath sep 'trialData\'];
figPath = [rootPath sep 'figure\' sep 'learningCurveTrialAll' sep]; mkdir(figPath);
trialData = cellfun(@(x)fn_selectProtocol(loadPath, x, selectProtocol),mice,'UniformOutput',false);

%[~, accuracy,~,~,~,~,~,~,~,~,~,~,probeData,~, ~,~,probeTrialNum,~,~]
outmat = cellfun(@(x)alignDays(x),trialData,'UniformOutput',false);

accuracy = cellfun(@(x)(x.accuracy),outmat,'UniformOutput',false);
bias = cellfun(@(x)(x.bias),outmat,'UniformOutput',false);
probeData = cellfun(@(x)(x.probeData),outmat,'UniformOutput',false);
probeTrialNum = cellfun(@(x)(x.probeTrialNum),outmat,'UniformOutput',false);
reactionTime = cellfun(@(x)(x.reactionTime),outmat,'UniformOutput',false);
lowActionDayFlag = cellfun(@(x)(x.lowActionDayFlag),outmat,'UniformOutput',false);
wheelPreSound = cellfun(@(x)(x.wheelPreSound),outmat,'UniformOutput',false);


trialLim = 2000;
trialBin = 0:250:trialLim;
probeAllAni = nan(length(probeData),length(trialBin)-1);
probeAllAniBias = nan(length(probeData),length(trialBin)-1);
for i= 1:length(probeData)
    trialNum = probeTrialNum{i}; 
    trialLimFlag = trialNum>trialLim; trialNum(trialLimFlag) = [];
    tempData = probeData{i}(~trialLimFlag,:);
    tempPerf = mean(tempData(:,1:2),2);
    tempBias = abs(tempData(:,5));
    
    binIdx = sum(trialNum>trialBin,2);
    probeAllAni(i,binIdx) = tempPerf;
    probeAllAniBias(i,binIdx) = tempBias;
end


nData = sum(~isnan(probeAllAni),1);
meanProbePerf = nanmean(probeAllAni,1); 
semProbePerf = nanstd(probeAllAni,0,1)./sqrt(nData);
meanProbeBias = nanmean(probeAllAniBias,1); 
semProbeBias = nanstd(probeAllAniBias,0,1)./sqrt(nData);

nanflag = isnan(meanProbePerf);
trialBinPlot = (trialBin(1:end-1) + trialBin(2:end))/2;

% REINF DATA
accuracy = cellfun(@(x)fn_attachNan(x,trialLim,1), accuracy, 'UniformOutput',false);
accuracy = cellfun(@(x)(x(1:trialLim)),accuracy,'UniformOutput',false);
accuracy = fn_cell2mat(accuracy,2);

%--------------------------------PLOT 1-----------------------------------
fn_figureSmartDim('hSize',0.25,'widthHeightRatio',1.8); hold on;
f_errorbar = fn_plotFillErrorbar(trialBinPlot(~nanflag),meanProbePerf(~nanflag),semProbePerf(~nanflag),...
    matlabColors(2),'faceAlpha',0.2,'LineStyle','none');
f_errorbar = fn_plotFillErrorbar(1:size(accuracy,1),(nanmean(accuracy,2))',...
    (nanstd(accuracy,0,2)./sqrt(size(accuracy,2)))',...
    matlabColors(1),'faceAlpha',0.2,'LineStyle','none');
% PLOT REINF
plot(nanmean(accuracy,2),'Color', matlabColors(1,0.9), 'LineWidth',2);
% PLOT PROBE AGAIN
plot(trialBinPlot(~nanflag),meanProbePerf(~nanflag),'--o','Color',matlabColors(2,0.9),'LineWidth',2)
plot([1 trialLim],[0.5 0.5],'Color',[0.6 0.6 0.6],'LineWidth',2);
xlim([1 trialLim]); ylabel('Accuracy'); xlabel('Trials');

%--------------------------------PLOT 2-----------------------------------
fn_figureSmartDim('hSize',0.25,'widthHeightRatio',1.8); hold on;
% PLOT REINF
for j = 1:size(accuracy,2)
    plot(accuracy(:,j),'Color', matlabColors(1,0.2), 'LineWidth',1);
end
for j = 1:size(probeAllAni,1)
    plot(trialBinPlot,probeAllAni(j,:),'--o','Color', matlabColors(2,0.4), 'LineWidth',1)
end
plot(nanmean(accuracy,2),'Color', matlabColors(1,0.9), 'LineWidth',2);
% PLOT PROBE AGAIN
plot(trialBinPlot(~nanflag),meanProbePerf(~nanflag),'--o','Color',matlabColors(2,0.9),'LineWidth',2)
plot([1 trialLim],[0.5 0.5],'Color',[0.6 0.6 0.6],'LineWidth',2);
xlim([1 trialLim]); ylabel('Accuracy'); xlabel('Trials');

%--------------------------------PLOT 3-----------------------------------
fn_figureSmartDim('hSize',0.25,'widthHeightRatio',1.8); hold on;
% PLOT REINF
for j = 1:size(accuracy,2)
    plot(accuracy(:,j),'Color', matlabColors(1,0.2), 'LineWidth',1);
end
plot(nanmean(accuracy,2),'Color', matlabColors(1,0.9), 'LineWidth',2);
plot([1 trialLim],[0.5 0.5],'Color',[0.6 0.6 0.6],'LineWidth',2);
xlim([1 trialLim]); ylabel('Accuracy'); xlabel('Trials');


%------------------------------REACTION TIME-------------------------------
reactionTime = cellfun(@(x,y)(fn_fillMat(x,logical(y))),reactionTime,lowActionDayFlag,'UniformOutput',false);
reactionTime = cellfun(@(x)fn_attachNan(x,trialLim,1), reactionTime, 'UniformOutput',false);
reactionTime = cellfun(@(x)(x(1:trialLim)),reactionTime,'UniformOutput',false);
reactionTime = fn_cell2mat(reactionTime,2);
reactionTime(reactionTime > 2.6) = nan; reactionTime(reactionTime < 0) = nan;
reactionTime = smoothdata(reactionTime,1,'movmean',50,'includenan');

fn_figureSmartDim('hSize',0.25,'widthHeightRatio',1.8); hold on;
for j = 1:size(accuracy,2)
    plot(reactionTime(:,j),'Color', matlabColors(1,0.2), 'LineWidth',1);
end
plot(nanmean(reactionTime,2),'Color', matlabColors(1,0.9), 'LineWidth',2);
ylim([0.3 1]); xlim([1 trialLim]);
ylabel('Reaction Time (s)'); xlabel('Trials');

%------------------------------Bias-------------------------------
bias = cellfun(@(x)fn_attachNan(x,trialLim,1), bias, 'UniformOutput',false);
bias = cellfun(@(x)(x(1:trialLim)),bias,'UniformOutput',false);
bias = fn_cell2mat(bias,2);
bias = abs(bias);
% REINF ONLY
fn_figureSmartDim('hSize',0.25,'widthHeightRatio',1.8); hold on;
for j = 1:size(bias,2)
    plot(bias(:,j),'Color', matlabColors(1,0.2), 'LineWidth',1);
end
plot(nanmean(bias,2),'Color', matlabColors(1,0.9), 'LineWidth',2);
xlim([1 trialLim]); ylim([0 0.6]); ylabel('Bias'); xlabel('Trials');
% REINF AND PROBE
fn_figureSmartDim('hSize',0.25,'widthHeightRatio',1.8); hold on;
plot(nanmean(bias,2),'Color', matlabColors(1,0.9), 'LineWidth',2);
f_errorbar = fn_plotFillErrorbar(1:size(bias,1),(nanmean(bias,2))',...
    (nanstd(bias,0,2)./sqrt(size(bias,2)))',...
    matlabColors(1),'faceAlpha',0.2,'LineStyle','none');
f_errorbar = fn_plotFillErrorbar(trialBinPlot(~nanflag),meanProbeBias(~nanflag),semProbeBias(~nanflag),...
    matlabColors(2),'faceAlpha',0.2,'LineStyle','none');
plot(trialBinPlot(~nanflag),meanProbeBias(~nanflag),'--o','Color',matlabColors(2,0.9),'LineWidth',2)
xlim([1 trialLim]); ylim([0 0.6]); ylabel('Bias'); xlabel('Trials');

%------------------------------ITI MOVEMENTS-------------------------------
wheelPreSound = cellfun(@(x)fn_attachNan(x,trialLim,1), wheelPreSound, 'UniformOutput',false);
wheelPreSound = cellfun(@(x)(x(1:trialLim)),wheelPreSound,'UniformOutput',false);
wheelPreSound = fn_cell2mat(wheelPreSound,2);
wheelPreSound = smoothdata(wheelPreSound,1,'movmean',50,'includenan');
wheelPreSound = wheelPreSound./repmat(nanmean(wheelPreSound(1:500,:),1),trialLim,1); %normalize to the first day of each animal
fn_figureSmartDim('hSize',0.25,'widthHeightRatio',1.8); hold on;
for j = 1:size(accuracy,2)
    plot(wheelPreSound(:,j),'Color', matlabColors(1,0.2), 'LineWidth',1);
end
plot(nanmean(wheelPreSound,2),'Color', matlabColors(1,0.9), 'LineWidth',2);
xlim([1 trialLim]);
ylabel('Reaction Time (s)'); xlabel('Trials');

%---------------------------PLOT MODEL TOGETHER----------------------------
weightCell = readModelPerformance(mice);
modelPerf = cellfun(@(x)fn_attachNan(x,trialLim,2), weightCell, 'UniformOutput',false);
modelPerf = cellfun(@(x)(x(1:trialLim)),modelPerf,'UniformOutput',false);
modelPerf = fn_cell2mat(modelPerf,1)';

fn_figureSmartDim('hSize',0.25,'widthHeightRatio',1.8); hold on;
% PLOT REINF
plot(nanmean(accuracy,2),'Color', matlabColors(1,0.9), 'LineWidth',2);
f_errorbar = fn_plotFillErrorbar(1:size(accuracy,1),(nanmean(accuracy,2))',...
    (nanstd(accuracy,0,2)./sqrt(size(accuracy,2)))',...
    matlabColors(1),'faceAlpha',0.2,'LineStyle','none');
% PLOT PROBE 
plot(trialBinPlot(~nanflag),meanProbePerf(~nanflag),'--o','Color',matlabColors(2,0.9),'LineWidth',2)
f_errorbar = fn_plotFillErrorbar(trialBinPlot(~nanflag),meanProbePerf(~nanflag),semProbePerf(~nanflag),...
    matlabColors(2),'faceAlpha',0.2,'LineStyle','none');

% PLOT MODEL
plot(nanmean(modelPerf,2),'Color', matlabColors(7,0.9), 'LineWidth',2);
f_errorbar = fn_plotFillErrorbar(1:size(modelPerf,1),(nanmean(modelPerf,2))',...
    (nanstd(modelPerf,0,2)./sqrt(size(modelPerf,2)))',...
    matlabColors(7),'faceAlpha',0.2,'LineStyle','none');
plot([1 trialLim],[0.5 0.5],'Color',[0.6 0.6 0.6],'LineWidth',2);
xlim([1 trialLim]); ylabel('Accuracy'); xlabel('Trials');

a = cellfun(@(x)(find(mean(x(:,1:2),2)>0.75)),probeData,'UniformOutput',false);
b = cellfun(@(x)(x(2)),a,'UniformOutput',false);
probeThreTrialNum = cellfun(@(x,y)(x(y)),probeTrialNum,b);
for i = 1:size(bias,2)
   bias_befProbe(i) = nanmean(bias(1:probeThreTrialNum,i));  
    
end





meanAcc = smoothdata(accuracy,'movmean',500);
meanBias = smoothdata(bias,'movmean',500);
for i = 1:7; firstHit70Temp = find(meanAcc(:,i)>0.7);
    if ~isempty(firstHit70Temp); firstHit70(i) = firstHit70Temp(1);
    else firstHit70(i) = inf;
    end
end
for i = 1:7; firstBias03Temp = find(meanBias(400:end,i)<0.3);
    if ~isempty(firstBias03Temp); firstBias03(i) = firstBias03Temp(1)+400;
    else firstBias03(i) = inf;
    end
end


figure;
scatter(max(firstHit70,firstBias03),nanmean(bias(1:700,:),1))

end