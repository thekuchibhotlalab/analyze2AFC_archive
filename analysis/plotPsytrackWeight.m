clear;
global loadPath;
loadPath = 'C:\Users\zzhu34\Documents\tempdata\octoData\psyTrackData\psyTrackFit\';
%modelComparison = {'S','SA','SRp','SRn','SRpRn','SB','SBA','SBRp','SBRn','SBRpRn'};

%% -------------------VISUALIZE WEIGHT TOGETHER COSYNE------------------------
nPrev = 1;
mouse = {'zz054','zz062','zz063','zz066','zz067','zz068','zz069'};
modelComparison = 'SBARpRn';

sW = []; bW = []; ahW = []; arhW = [];
for i = 1:length(mouse)
    load([loadPath filesep mouse{i} 'psytrack_' modelComparison '_nPrev' int2str(nPrev) '.mat']);
    sW{i} = wMode(5,:); bW{i} = abs(wMode(4,:)); ahW{i} = abs(wMode(1,:)); arhW{i} = abs(wMode(3,:));
end
sW = fn_cell2matFillNan(sW); bW = fn_cell2matFillNan(bW); ahW = fn_cell2matFillNan(ahW); arhW = fn_cell2matFillNan(arhW);

figure; hold on
f_errorbar = fn_plotFillErrorbar(1:size(sW,2),nanmean(sW,1),nanstd(sW,0,1)./sqrt(sum(~isnan(sW),1)),...
    matlabColors(1),'faceAlpha',0.2,'LineStyle','none');
plot(nanmean(sW,1),'Color', matlabColors(1,0.9), 'LineWidth',2);

f_errorbar = fn_plotFillErrorbar(1:size(bW,2),nanmean(bW,1),nanstd(bW,0,1)./sqrt(sum(~isnan(bW),1)),...
    matlabColors(2),'faceAlpha',0.2,'LineStyle','none');
plot(nanmean(bW,1),'Color', matlabColors(2,0.9), 'LineWidth',2);

f_errorbar = fn_plotFillErrorbar(1:size(ahW,2),nanmean(ahW,1),nanstd(ahW,0,1)./sqrt(sum(~isnan(ahW),1)),...
    matlabColors(3),'faceAlpha',0.2,'LineStyle','none');
plot(nanmean(ahW,1),'Color', matlabColors(3,0.9), 'LineWidth',2);

f_errorbar = fn_plotFillErrorbar(1:size(arhW,2),nanmean(arhW,1),nanstd(arhW,0,1)./sqrt(sum(~isnan(arhW),1)),...
    matlabColors(4),'faceAlpha',0.2,'LineStyle','none');
plot(nanmean(arhW,1),'Color', matlabColors(4,0.9), 'LineWidth',2);
ylim([-0.2 2.2]); yticks([0 1 2])
xlim([0 2000]);xticks([0 500 1000 1500 2000])
disp('none')

%% ----------------MODEL FIT COSYNE-------------------
clear;
nPrev = 1;
loadPath = 'C:\Users\zzhu34\Documents\tempdata\octoData\psyTrackData\psyTrackFit\';
mouse = 'zz063';
modelComparison = 'SBARpRn';
load(['C:\Users\zzhu34\Documents\tempdata\octoData\psyTrackData\trialData' filesep mouse '_nPrev5.mat']);

load([loadPath filesep mouse 'psytrack_' modelComparison '_nPrev' int2str(nPrev) '.mat']);
regressor = [actionH(:,1),actionXnegRewardH(:,1),actionXposRewardH(:,1),ones(size(stimulus)),stimulus];
predChoice = fn_logistic (sum(regressor .* wMode',2));
predAcc = (answer==2) .* predChoice + (1-(answer==2)).* (1-predChoice);
figure; hold on;
tempBeh = smoothdata(correct,'movmean',50); tempModel = smoothdata(predAcc,'movmean',50);
plot(tempBeh,'LineWidth',2)
plot(tempModel,'LineWidth',2)
disp(['R-square = ' num2str(corr(tempBeh,tempModel)^2,'%.3f')])
xlim([0 2500]); xticks(0:500:2500); yticks(0.2:0.2:1);ylim([0.2 1])





%% -------------------VISUALIZE WEIGHT IN ALL MODELS------------------------
nPrev = 3;
mouse = {'zz054','zz062','zz063','zz066','zz067','zz068','zz069'};

% Action Bias visualization
wName = 'B';modelComparison = {'SB','SBA','SBRp','SBRn','SBRpRn'};
wIdx = {1,nPrev+1,nPrev+1,nPrev+1,nPrev*2+1};
w = loadW(mouse,modelComparison,wIdx,nPrev,true);
plotW_allModel(w,wName,modelComparison)

% Action history visualization - history 1
wName = 'A1';modelComparison = {'SA','SBA'}; wIdx = {1,1,1};
w = loadW(mouse,modelComparison,wIdx,nPrev,false);
plotW_allModel(w,wName,modelComparison)

% Action history visualization - history 2
wName = 'A2';modelComparison = {'SA','SBA'}; wIdx = {2,2,2};
w = loadW(mouse,modelComparison,wIdx,nPrev,false);
plotW_allModel(w,wName,modelComparison)

% Action history visualization - history 3
wName = 'A3';modelComparison = {'SA','SBA'}; wIdx = {3,3,3};
w = loadW(mouse,modelComparison,wIdx,nPrev,false);
plotW_allModel(w,wName,modelComparison)

% ActionReward history visualization - history 1
wName = 'Rp1';modelComparison = {'SRp','SRpRn','SBRp','SBRpRn'}; wIdx = {1,1,1,nPrev+1};
w = loadW(mouse,modelComparison,wIdx,nPrev,false);
plotW_allModel(w,wName,modelComparison)

% ActionReward history visualization - history 2
wName = 'Rp2';modelComparison = {'SRp','SRpRn','SBRp','SBRpRn'}; wIdx = {2,2,2,nPrev+2};
w = loadW(mouse,modelComparison,wIdx,nPrev,false);
plotW_allModel(w,wName,modelComparison)

% ActionReward history visualization - history 3
wName = 'Rp3';modelComparison = {'SRp','SRpRn','SBRp','SBRpRn'}; wIdx = {3,3,3,nPrev+3};
w = loadW(mouse,modelComparison,wIdx,nPrev,false);
plotW_allModel(w,wName,modelComparison)

%% -------------------VISUALIZE BIAS WEIGHT CONTRIBUTION TO CHOICE------------------------
wName = 'B';modelComparison = {'SBRpRn'}; wIdx = {nPrev*2+1};
wAccuracy = {};
figure; subplot(1,3,1); hold on;
w = loadW(mouse,modelComparison,wIdx,nPrev,false);w = w{1}; wChoice = fn_logistic(w);
plot((wChoice'),'Color',[0.8 0.8 0.8]); plot(nanmean((wChoice),1),'Color',[0 0 0])
xlim([1 3500]); ylim([0 1])
subplot(1,3,2); hold on;
w = loadW(mouse,modelComparison,wIdx,nPrev,true);w = w{1}; wChoice = fn_logistic(w);
plot((wChoice'),'Color',[0.8 0.8 0.8]); plot(nanmean((wChoice),1),'Color',[0 0 0])
xlim([1 3500]); ylim([0.5 1])

w = loadW(mouse,modelComparison,wIdx,nPrev,false);w = w{1}; wChoice = fn_logistic(w);
for i = 1:size(w,1)
    load(['C:\Users\zzhu34\Documents\tempdata\octoData\psyTrackData\trialData\' filesep mouse{i} '_nPrev5.mat']);
    wAccuracy{i} = (y==1) .* (1-wChoice(i,1:length(y)))' + (y==2) .* (wChoice(i,1:length(y)))';
end
wAccuracy = fn_cell2matFillNan(wAccuracy); wAccuracySmooth = smoothdata(wAccuracy,1,'movmean',100);
subplot(1,3,3); hold on;
plot((wAccuracySmooth),'Color',[0.8 0.8 0.8]); plot(nanmean((wAccuracySmooth),2),'Color',[0 0 0])
xlim([1 3500]); ylim([0.4 0.9])
%% -------------------VISUALIZE HISTORY WEIGHT CONTRIBUTION TO CHOICE------------------------
wName = 'Rp';model = 'SRp'; wIdx = 1:3;
[choice,choicePred,accuracy] = loadMultipleW(mouse,model,wIdx,'actionXposRewardH',nPrev);
figure; subplot(1,2,1); hold on; binChoicePred = smoothdata(choicePred,1,'movmean',50);
plot(binChoicePred,'Color',[0.8 0.8 0.8]); plot(nanmean((binChoicePred),2),'Color',[0 0 0])
xlim([1 3500]); ylim([0.4 0.6]); title('Choice Prediction')
subplot(1,2,2); hold on; binAcc = smoothdata(accuracy,1,'movmean',50);
plot(binAcc,'Color',[0.8 0.8 0.8]); plot(nanmean(binAcc,2),'Color',[0 0 0])
xlim([1 3500]); ylim([0.4 0.6]); title('Accuracy')

%% -------------------VISUALIZE HISTORY WEIGHT CONTRIBUTION TO CHOICE------------------------
wName = 'Rn';model = 'SRn'; wIdx = 1:3;
[choice,choicePred,accuracy] = loadMultipleW(mouse,model,wIdx,'actionXnegRewardH',nPrev);
figure; subplot(1,2,1); hold on; binChoicePred = smoothdata(choicePred,1,'movmean',50);
plot(binChoicePred,'Color',[0.8 0.8 0.8]); plot(nanmean((binChoicePred),2),'Color',[0 0 0])
xlim([1 3500]); ylim([0.4 0.7]); title('Choice Prediction')
subplot(1,2,2); hold on; binAcc = smoothdata(accuracy,1,'movmean',50);
plot(binAcc,'Color',[0.8 0.8 0.8]); plot(nanmean(binAcc,2),'Color',[0 0 0])
xlim([1 3500]); ylim([0.4 0.7]); title('Accuracy')

%% -------------------VISUALIZE ACTION HISTORY WEIGHT CONTRIBUTION TO CHOICE------------------------
wName = 'A';model = 'SA'; wIdx = 1:3;
[choice,choicePred,accuracy] = loadMultipleW(mouse,model,wIdx,'actionH',nPrev);
figure; subplot(1,2,1); hold on; binChoicePred = smoothdata(choicePred,1,'movmean',50);
%temp = abs(binChoicePred-0.5)+0.5;
plot(binChoicePred,'Color',[0.8 0.8 0.8]); plot(nanmean((binChoicePred),2),'Color',[0 0 0])
xlim([1 3500]); ylim([0.4 0.73]); title('Choice Prediction')
subplot(1,2,2); hold on; binAcc = smoothdata(accuracy,1,'movmean',50);
plot(binAcc,'Color',[0.8 0.8 0.8]); plot(nanmean(binAcc,2),'Color',[0 0 0])
xlim([1 3500]); ylim([0.4 0.75]); title('Accuracy')

%% -------------------VISUALIZE ACTION HISTORY WEIGHT CONTRIBUTION TO CHOICE------------------------
[choice,choicePred,accuracy] = loadFullW(mouse,nPrev);
figure; subplot(1,2,1); hold on; binChoicePred = smoothdata(choicePred,1,'movmean',50);
%temp = abs(binChoicePred-0.5)+0.5;
plot(binChoicePred,'Color',[0.8 0.8 0.8]); plot(nanmean((binChoicePred),2),'Color',[0 0 0])
xlim([1 3500]); ylim([0.1 0.9]); title('Choice Prediction')
subplot(1,2,2); hold on; binAcc = smoothdata(accuracy,1,'movmean',50);
plot(binAcc,'Color',[0.8 0.8 0.8]); plot(nanmean(binAcc,2),'Color',[0 0 0])
xlim([1 3500]); ylim([0.4 0.8]); title('Accuracy')

%% -------------------All FUNCTIONS------------------------
function w = loadW(mouse,modelComparison,wIdx,nPrev,absFlag)
global loadPath;
for i = 1:length(modelComparison)
    tempW = {};
    for j = 1:length(mouse)
        if strcmp(modelComparison{i},'S') || strcmp(modelComparison{i},'SB')
            load([loadPath filesep mouse{j} 'psytrack_' modelComparison{i} '.mat'])
        else
            load([loadPath filesep mouse{j} 'psytrack_' modelComparison{i} '_nPrev' int2str(nPrev) '.mat'])
        end
        if absFlag; tempW{j} = abs(wMode(wIdx{i},:));
        else ; tempW{j} = wMode(wIdx{i},:);
        end
    end
    w{i} = fn_cell2matFillNan(tempW);
end
end


function [choice, choicePred,accuracy] = loadMultipleW(mouse,model,wIdx,varName,nPrev)

global loadPath;
for j = 1:length(mouse)
    if strcmp(model,'S') || strcmp(model,'SB')
        load([loadPath filesep mouse{j} 'psytrack_' model '.mat'])
    else
        load([loadPath filesep mouse{j} 'psytrack_' model '_nPrev' int2str(nPrev) '.mat'])
    end
    
    load(['C:\Users\zzhu34\Documents\tempdata\octoData\psyTrackData\trialData' filesep mouse{j} '_nPrev5.mat']);
    behavVar = eval(varName);
    choicePred{j} = fn_logistic(sum(wMode(wIdx,:)' .* behavVar(:,wIdx),2));
    choice{j} = y;
    accuracy{j} = (y==1) .* (1-choicePred{j}) + (y==2) .* (choicePred{j});
    
end

choice = fn_cell2matFillNan(choice);
choicePred = fn_cell2matFillNan(choicePred);
accuracy = fn_cell2matFillNan(accuracy);

end


function [choice, choicePred,accuracy] = loadFullW(mouse,nPrev)
model = 'SBARpRn';
global loadPath;
for j = 1:length(mouse)
    if strcmp(model,'S') || strcmp(model,'SB')
        load([loadPath filesep mouse{j} 'psytrack_' model '.mat'])
    else
        load([loadPath filesep mouse{j} 'psytrack_' model '_nPrev' int2str(nPrev) '.mat'])
    end
    
    load(['C:\Users\zzhu34\Documents\tempdata\octoData\psyTrackData\trialData' filesep mouse{j} '_nPrev5.mat']);
    
    regressor = cat(2,actionH(:,1:nPrev), actionXnegRewardH(:,1:nPrev), actionXposRewardH(:,1:nPrev), ones(size(actionH,1),1));
    
    choicePred{j} = fn_logistic(sum(regressor.* wMode(1:end-1,:)',2));
    choice{j} = y;
    accuracy{j} = (y==1) .* (1-choicePred{j}) + (y==2) .* (choicePred{j});
    
end

choice = fn_cell2matFillNan(choice);
choicePred = fn_cell2matFillNan(choicePred);
accuracy = fn_cell2matFillNan(accuracy);

end


function plotW_allModel(w,wName,modelComparison)
figure; [nRow,nColumn] = fn_sqrtInt(length(w));
for i = 1:length(w)
    subplot(nRow,nColumn,i); hold on;
    plot(w{i}','Color',[0.8 0.8 0.8]); plot(nanmean(w{i},1),'Color',[0 0 0])
    xlim([0 3500]); title([wName ' - ' modelComparison{i}]); xlabel('Trials'); ylabel('Weight')
    if i == 1; ylimm = ylim; else; ylim(ylimm); end
end
end

