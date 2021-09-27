function [accuracy,accuracyTop,accuracyMean,acc_L,accMean_L,acc_R,accMean_R,...
    bias,bias_absMean,missBias,probeData,reinfDataBef, reinfDataAft,trialNum,probeTrialNum,probeDayNum,dayLen] = alignDays(trialData)

learningCurveBin = 50;

% convert stimulus type from 1 or 2 to 1 or -1 for plotting
stimulus = trialData.stimulus;
stimulus = fn_cell2mat(cellfun(@(x)(smoothdata(-x*2+3,'movmean',...
    learningCurveBin)),stimulus,'UniformOutput',false),1);

responseType = trialData.responseType; 

actionRate = cellfun(@(x)(smoothdata(double(x~=0),'movmean',...
    learningCurveBin)),responseType,'UniformOutput',false);

accuracy = cellfun(@(x)(smoothdata(double(x==1),'movmean',...
    learningCurveBin)),responseType,'UniformOutput',false);

accuracyCellByDay = cellfun(@(x,y)(x./y),accuracy,actionRate,'UniformOutput',false);
accuracyTop = fn_cell2mat(cellfun(@(x)(prctile(x,90)),accuracyCellByDay,'UniformOutput',false),1);
accuracyMean = fn_cell2mat(cellfun(@nanmean,accuracyCellByDay,'UniformOutput',false),1);

[actionRate, ~] = fn_cell2mat(actionRate,1);
[accuracy, cellSize] = fn_cell2mat(accuracy,1);
accuracy = accuracy./actionRate;

[bias, acc_L, acc_R] = cellfun(@getBias,trialData.stimulus,trialData.responseType,'UniformOutput',false);

bias_absMean = fn_removeEmptyEntryCell(bias);
bias_absMean = cellfun(@(x)(nanmean(abs(x))), bias_absMean,'UniformOutput',false);
bias_absMean = fn_cell2mat(bias_absMean,1);

accMean_L = fn_removeEmptyEntryCell(acc_L); accMean_R = fn_removeEmptyEntryCell(acc_R);
accMean_L = fn_cell2mat(cellfun(@nanmean, accMean_L,'UniformOutput',false),1);
accMean_R = fn_cell2mat(cellfun(@nanmean, accMean_R,'UniformOutput',false),1);

bias = fn_cell2mat(bias,1); acc_L = fn_cell2mat(acc_L,1); acc_R = fn_cell2mat(acc_R,1);



missBias = cellfun(@getMissBias,trialData.stimulus,trialData.responseType,'UniformOutput',false);
missBias = fn_cell2mat(missBias,1);
%--------PROBE ORGANIZE BY DAY---------
[probeData, trialNum,probeTrialNum,trialNumNoMiss,probeTrialNumNoMiss,reinfDataBef, reinfDataAft]...
    = cellfun(@getProbe,trialData.stimulus,trialData.responseType,trialData.context,'UniformOutput',false);

probeData = fn_cell2mat(probeData,1);
reinfDataBef = fn_cell2mat(reinfDataBef,1);
reinfDataAft = fn_cell2mat(reinfDataAft,1);

trialNum = fn_cell2mat(trialNum,1);
probeTrialNum = fn_cell2mat(probeTrialNum,1);
probeDayNum = find(~isnan(probeTrialNum));

cumsumTrials = [0;cumsum(trialNum)];
probeTrialNum = probeTrialNum + cumsumTrials(1:end-1);
probeTrialNum(isnan(probeTrialNum)) = [];

dayLen = cellSize(1,:); dayLen(dayLen==0) = [];



end