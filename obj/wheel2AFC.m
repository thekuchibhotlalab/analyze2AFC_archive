classdef wheel2AFC < twoChoiceTask
    % wheel2AFC - sub-class of twoChoiceTask for ONE mouse
    %   wheel2AFC should contain all the training days from wheel training
    %   to 2AFC training
    %   
    
    properties
        % structure containing info about wheel movement
        wheel
    end
    
    methods
        %-----------------------------CONSTRUCTOR METHODS-----------------------------------------
        function obj = wheel2AFC(inStruct)
            %MOUSEOBJ Construct an instance of this class
            %   Detailed explanation goes here
            obj = obj@twoChoiceTask(inStruct);
            
            inputNames = fieldnames(inStruct);
            
            % Write input into MULTIDAY
            multiDayNames = {'date','trainingType','sortIdx'};
            obj.multiday = write2struct(obj.multiday,multiDayNames);
            
            % Write input into WHEEL
            wheelNames = {'wheelSoundOn','wheelPreSound','wheelSoundOnCheckFlag'};
            obj.wheel = write2struct(obj.wheel,wheelNames);
            
            function S = write2struct(S,varNames)
                for i = 1:length(varNames)
                    if contains(varNames{i},inputNames)
                        S.(varNames{i}) = inStruct.(varNames{i});
                    end 
                end  
            end
        end
        %-----------------------------METHODS EXTENDING FROM TWOCHOICETASK CLASS-----------------------------------------
        function obj = concatenateDay(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj = concatenateDay@twoChoiceTask(obj);
            wheelPropSel = {'wheelPreSound'};
            for i = 1:length(wheelPropSel)
                if iscell(obj.(wheelPropSel{i})); obj.(wheelPropSel{i}) = fn_cell2mat(obj.(wheelPropSel{i}),1);end
            end
        end
        
        function obj = selectDay(obj,selectFlag)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj = selectDay@twoChoiceTask(obj,selectFlag);
            multidayPropSel = {'date','trainingType','sortIdx'};
            for i = 1:length(multidayPropSel); obj.multiday.(multidayPropSel{i}) = obj.multiday.(multidayPropSel{i})(selectFlag);end
            wheelPropSel = {'wheelPreSound','wheelSoundOn','wheelSoundOnCheckFlag'};
            for i = 1:length(wheelPropSel); obj.wheel.(wheelPropSel{i}) = obj.wheel.(wheelPropSel{i})(selectFlag);end
        end
        
        %-----------------------------METHODS SPECIFIC TO WHEEL 2AFC CLASS-----------------------------------------
        function obj = selectProtocol(obj,selectProtocol)
            selectFlag = fn_multistrcmp(obj.multiday.trainingType,selectProtocol);
            obj = selectDay(obj,selectFlag);
        end
        
        
        
        function a = b(obj)
            
            
        end
        
        
        
    end
end
