clear; close all;
mice = {'zz054','zz062','zz063','zz066','zz067','zz068','zz069'};
%mice = {'zz066','zz067','zz068','zz069'};
%mice = {'zz054'};
%% save coulbourn data to datapath
cellfun(@readCoulbournData,mice,'UniformOutput',false);

%% plot learning curve of each mouse
cellfun(@plotLearningCurveTrial,mice,'UniformOutput',false);
%% align mouse learning curve with miss trials
plotLearningCurveTrialAll(mice);
%% align mouse learning curve without miss trials
plotLearningCurveTrialAllNoMiss(mice);