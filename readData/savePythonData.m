mouse = 'zz066';
dataPath = 'C:\Users\zzhu34\Documents\tempData\octoData\trialData\';
targetPath = 'C:\Users\zzhu34\Documents\tempData\octoData\psyTrackData\';
mkdir(targetPath);
sep = '\';
load([dataPath sep mouse '.mat']);
nPrev = 3;
nSplit = 3;

%% GET TRIAL VARIABLES
stimulus = fn_cell2mat(trialData.stimulus,1); % stimulus, 1 or 2, need to change to -1 and 1
action = fn_cell2mat(trialData.action,1); % action, 1 or 2, need to change to -1 and 1 for action history, 
correct = fn_cell2mat(trialData.responseType,1);% correct or not, 1 or 2, need to chagne to 1 or 0

% make sure that 
missFlag = (action == 0); missIdx = find(missFlag); 
if mod(sum(~missFlag),nSplit) ~= 0 
    reminder =  mod(sum(~missFlag),nSplit); 
    hitIdx = find(missFlag==0); missFlag(hitIdx(end-(reminder-1):end)) = 1;
end

stimulus(missFlag) = []; action(missFlag) = []; correct(missFlag) = [];

y = action; % Choice, 1 or 2, target variable
answer = stimulus; % Correct Answer (same with stimulus), 1 or 2
correct(correct==2) = 0; % Reward, correct or not. 1 or 0 (changed from 1 and 2)
stimulus = stimulus*2 - 3; % Stimulus, Change from 1 or 2 to -1 or 1;
action = action*2-3; % Choice, Change from 1 or 2 to -1 or 1;
actionXreward = action .* correct; % ChoiceXreward, only positive reward is predictive

stimH = getTrialHistory(stimulus, nPrev); % Stimulus History, i.e. choice X reward
actionH = getTrialHistory(action, nPrev);
actionXrewardH = getTrialHistory(actionXreward, nPrev); % Choice History

sameStimFlag = double(stimH == repmat(stimulus,[1 nPrev])); 
actionXrewardXcurrstimH = actionXrewardH.* sameStimFlag; % PrevStim X Curr Stim (only same stimulus) X PrevChoice X reward

%% GET DAYLENGTH
dayLength = [];
for i = 1:length(trialData.responseType)
    temp = trialData.responseType{i}; 
    temp(temp==0) = []; 
    dayLength(i) = length(temp); 
end
dayLength(dayLength == 0 ) = [];

%% SAVE DATA

save([targetPath sep mouse '.mat'],'y','answer','correct','stimulus','stimH',...
    'actionH','actionXrewardH','actionXrewardXcurrstimH','dayLength');

%% FUNCTIONS
function trialHistory = getTrialHistory(currTrial, nPrev)

trialHistory = zeros(length(currTrial),nPrev);
for i = 1:nPrev
    trialHistory(:,i) = circshift(currTrial,i);
    trialHistory(1:i,i) = 0;
end

end