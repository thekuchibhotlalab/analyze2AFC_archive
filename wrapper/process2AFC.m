clear; close all;
mice = {'zz054','zz062','zz063','zz066','zz067','zz068','zz069'};
%mice = {'zz066','zz067','zz068','zz069'};
%mice = {'zz081','zz082','zz083'}; %FM mice
%mice = {'zz075','zz076','zz077','zz048','zz049'}; %FM 2 oct/s
%mice = {'zz065','zz066','zz079'}; %AM_PT
%mice = {'zz060','zz062','zz063','zz064'}; %AM_WN
%% save coulbourn data to datapath
cellfun(@readCoulbournData,mice,'UniformOutput',false);

%% plot learning curve of each mouse
cellfun(@(x)plotLearningCurveTrial(x,{'puretone'}),mice,'UniformOutput',false);
%% align mouse learning curve with miss trials
plotLearningCurveTrialAll(mice,{'FM_UpDown'});
%% align mouse learning curve without miss trials
plotLearningCurveTrialAllNoMiss(mice,{'puretone'});
%plotLearningCurveTrialAllNoMiss(mice,{'FM_UpDown'});
%plotLearningCurveTrialAllNoMiss(mice,{'FM_Multi_Oct','FM_Multi_Oct_Prob'});
%plotLearningCurveTrialAllNoMiss(mice,{'AM_puretone'});
%plotLearningCurveTrialAllNoMiss(mice,{'AM'});

%% align mouse learning curve without miss trials
plotBiasTransition(mice,{'puretone'});


