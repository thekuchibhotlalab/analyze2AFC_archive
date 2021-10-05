function trialData = alignDays(trialData)


for i = 1:length(trialData.stimulus)
    if ~trialData.wheelSoundOnCheckFlag{i}
        trialData.wheelPreSound{i} = nan(length(trialData.stimulus{i}),1);
    end
    
end
trialDataKeepMiss = trialData;
rmFieldnames = {'date','trainingType','wheelSoundOn','wheelSoundOnCheckFlag','sortIdx'};
trialData = rmfield(trialData,rmFieldnames);
learningCurveBin = 50;

% calculate trial each day 
dayLen = cellfun(@length, trialDataKeepMiss.action);
dayLenNoMiss = cellfun(@(x)(sum(x~=0)), trialDataKeepMiss.action);
lowActionDayFlag = zeros(sum(dayLenNoMiss),1);
tempActionRate = dayLenNoMiss./dayLen;
dayLenNoMissCumSum = [0 cumsum(dayLenNoMiss)];
for i = 1:length(dayLenNoMiss)
    if tempActionRate(i)<0.6
        lowActionDayFlag(dayLenNoMissCumSum(i)+1:dayLenNoMissCumSum(i+1)) = 1;
    end
end

% concatenate trials
trialData = structfun(@(x)fn_cell2mat(x,1),trialData,'UniformOutput',false);

missFlag = trialData.action==0;
probeFlag = trialData.context==3;

trialData = structfun(@(x)fn_removeIdx(x,missFlag),trialData,'UniformOutput',false);

trialData.accuracy = smoothdata(double(trialData.responseType==1),'movmean',learningCurveBin);

[trialData.bias, trialData.acc_L, trialData.acc_R] = fn_getBias(trialData.stimulus,trialData.responseType);


[probeData, ~,~,trialNumNoMiss,probeTrialNumNoMiss,reinfDataBef, reinfDataAft]...
    = cellfun(@fn_getProbe,trialDataKeepMiss.stimulus,trialDataKeepMiss.responseType,trialDataKeepMiss.context,'UniformOutput',false);

trialData.probeData = fn_cell2mat(probeData,1);
trialData.reinfDataBef = fn_cell2mat(reinfDataBef,1);
trialData.reinfDataAft = fn_cell2mat(reinfDataAft,1);

trialNum = fn_cell2mat(trialNumNoMiss,1);
probeTrialNum = fn_cell2mat(probeTrialNumNoMiss,1);
trialData.probeDayNum = find(~isnan(probeTrialNum));

cumsumTrials = [0;cumsum(trialNum)];
probeTrialNum = probeTrialNum + cumsumTrials(1:end-1);
probeTrialNum(isnan(probeTrialNum)) = [];

trialData.trialNum = trialNum;
trialData.probeTrialNum = probeTrialNum;


trialData.reactionTime = trialData.reactionTime;

% convert stimulus type from 1 or 2 to 1 or -1 for plotting
trialData.stimulus = smoothdata(-trialData.stimulus*2+3,'movmean',learningCurveBin);
trialData.lowActionDayFlag = lowActionDayFlag;
end