
function trialData = fn_selectAnimalDay(trialData,mouse)

switch mouse
    case 'zz054'
        maxDay = 20210610;
    case 'zz062'
        maxDay = 20210621;
    case 'zz063'
        maxDay = 20210611;
    
    case 'zz066'
        maxDay = 20210619;
    case 'zz067'
        maxDay = 20210706;
    case 'zz068'
        maxDay = 20210622;
    case 'zz069'
        maxDay = 20210629;
            
end

tempDate = cellfun(@str2double,trialData.date);
trialData = fn_readStructByFlag(trialData,tempDate<=maxDay);

end