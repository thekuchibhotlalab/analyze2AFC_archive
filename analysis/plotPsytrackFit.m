clear;
loadPath = 'C:\Users\zzhu34\Documents\tempdata\octoData\psyTrackData\psyTrackFit\';
nPrev = 3;

mouse = {'zz054','zz062','zz063','zz066','zz067','zz068','zz069'};
%modelComparison = {'S','SA','SRp','SRn','SRpRn','SARpRn','SB','SBA','SBRp','SBRn','SBRpRn'};
modelComparison = {'S','SA','SRp','SRn','SB'};

for i = 1:length(modelComparison)
    for j = 1:length(mouse)
        if strcmp(modelComparison{i},'S') || strcmp(modelComparison{i},'SB')
            load([loadPath filesep mouse{j} 'psytrack_' modelComparison{i} '.mat'])
        else
            load([loadPath filesep mouse{j} 'psytrack_' modelComparison{i} '_nPrev' int2str(nPrev) '.mat'])
        end
        loglikeli(i,j) = xval_logli/length(xval_pL);
    end
end

loglikeli = loglikeli(2:end,:) - repmat(loglikeli(1,:),size(loglikeli,1)-1,1);
figure;
bar(mean(loglikeli,2),'EdgeColor',[1 1 1],'FaceColor',matlabColors(2,0.9)); hold on;

for i = 1:size(loglikeli,1)
    scatter(i*ones(size(loglikeli,2),1) ,loglikeli(i,:),10,[0 0 0],'filled');
end

xticklabels(modelComparison(2:end))
xtickangle(45); ylabel('log-likeli increase over stimulus-only model')
title(['Prev History ' int2str(nPrev)]); ylim([0 0.12])

%% -------------- PLOT FOR COSYNE-----------------------
nPrev = 3;
mouse = {'zz054','zz062','zz063','zz066','zz067','zz068','zz069'};
modelComparison = {'S','SARpRn','SB','SBARpRn'};

loglikeli = [];
for i = 1:length(modelComparison)
    for j = 1:length(mouse)
        if strcmp(modelComparison{i},'S') || strcmp(modelComparison{i},'SB')
            load([loadPath filesep mouse{j} 'psytrack_' modelComparison{i} '.mat'])
        else
            load([loadPath filesep mouse{j} 'psytrack_' modelComparison{i} '_nPrev' int2str(nPrev) '.mat'])
        end
        loglikeli(i,j) = -xval_logli/length(xval_pL);
    end
end

figure;hold on;
bar(mean(loglikeli,2),'EdgeColor',matlabColors(2),'LineWidth',3,'FaceColor',[1 1 1]); hold on;
errorbar(mean(loglikeli,2),std(loglikeli,0,2)./sqrt(size(loglikeli,2)),'.','Color',matlabColors(2),'LineWidth',3);
ylim([0.4 0.6]); xlim([0.5 4.5]);xticks([]);ylabel('Neg-loglikeli'); yticks([0.4:0.05:0.6])