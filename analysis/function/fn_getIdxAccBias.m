function idxData = fn_getIdxAccBias(stim, resp, idx)

if max(idx) <= length(stim)
    idxStim = stim(idx); idxResponse = resp(idx);
    tempResp = idxResponse(idxStim==1);

    idxData(1) = sum(tempResp==1) / sum(tempResp~=0); % Accuracy L
    idxData(3) = sum(tempResp~=0) / length(tempResp); % Action rate L

    tempResp = idxResponse(idxStim==2);
    idxData(2) = sum(tempResp==1) / sum(tempResp~=0); % Accuracy R
    idxData(4) = sum(tempResp~=0) / length(tempResp); % Action rate R

    idxData(5) = (idxData(1) - idxData(2)); %/ (probeData(1) + probeData(2));
else
    idxData = nan(1,5);
end

end