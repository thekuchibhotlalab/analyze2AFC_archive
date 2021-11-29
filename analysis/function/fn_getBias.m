function [bias,acc_L,acc_R] = fn_getBias(stimulus,responeType,biasBin)
    if nargin<3; biasBin = 100; end
    correct = (responeType == 1);
    miss = (responeType == 0);
    bias = nan(size(correct)); acc_L = nan(size(correct)); acc_R = nan(size(correct));
    for j = biasBin:length(correct)
        tempCorrect = correct((j-biasBin+1):j);
        tempMiss = miss((j-biasBin+1):j);
        tempStim = stimulus((j-biasBin+1):j);
        acc_s1 = sum(tempCorrect & tempStim==1) / sum(tempStim==1 & tempMiss~=1);
        acc_s2 = sum(tempCorrect & tempStim==2) / sum(tempStim==2 & tempMiss~=1);
        bias(j - biasBin/2) = (acc_s1 - acc_s2); % / (acc_s1 + acc_s2);
        acc_L(j - biasBin/2) = acc_s1; acc_R(j - biasBin/2) = acc_s2;
    end
end