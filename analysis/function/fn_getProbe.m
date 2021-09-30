function [probeData, trialNum, probeTrialNum, trialNumNoMiss, probeTrialNumNoMiss,...
    reinfDataBef, reinfDataAft] = fn_getProbe(stim, response,ctxt)
    
probeIdx = find(ctxt==3); nProbeRaw = length(probeIdx);

trialNumNoMissIdx = cumsum((response~=0));

probeData = []; reinfDataBef = []; reinfDataAft = [];
goodProbeFlag = true;
% Two probe sessions 
if ~isempty(probeIdx)
    if mod(nProbeRaw,10) == 2 && nProbeRaw==22
        probeIdx([1,12]) = [];
        reinfBefIdx = probeIdx-10; reinfAftIdx = probeIdx+10;
    elseif mod(nProbeRaw,10) == 1 && (nProbeRaw==11 || nProbeRaw==21)
        probeIdx(1) = [];
        if nProbeRaw == 11
            reinfBefIdx = probeIdx-10; reinfAftIdx = probeIdx+10;
        elseif nProbeRaw == 21
            reinfBefIdx = probeIdx-20; reinfAftIdx = probeIdx+20;
        end
        
    elseif nProbeRaw==20
        if (nProbeRaw(end)- nProbeRaw(1))~=19
            reinfBefIdx = probeIdx-10; reinfAftIdx = probeIdx+10;
        else 
            reinfBefIdx = probeIdx-20; reinfAftIdx = probeIdx+20;
        end   
    elseif nProbeRaw==10
        reinfBefIdx = probeIdx-10; reinfAftIdx = probeIdx+10;
    else
        disp(['WARNING -- Exception in Probe! nProbe = ' int2str(nProbeRaw)]);
        probeTrialNum = nan; probeTrialNumNoMiss = nan;
        goodProbeFlag = false;
    end
    if goodProbeFlag
        probeData = fn_getIdxAccBias(stim, response, probeIdx);
        reinfDataBef = fn_getIdxAccBias(stim, response, reinfBefIdx);
        reinfDataAft = fn_getIdxAccBias(stim, response, reinfAftIdx);

        probeTrialNum = round(mean(probeIdx));

        probeTrialNumNoMiss = round(mean(trialNumNoMissIdx(probeIdx)));
    end
else
    probeTrialNum = nan; probeTrialNumNoMiss = nan;
end
if isempty(ctxt); trialNum = nan; trialNumNoMiss = nan; %probeTrialNum = []; probeTrialNumNoMiss = []; 
else; trialNum = length(ctxt); trialNumNoMiss = max(trialNumNoMissIdx);
end 

end