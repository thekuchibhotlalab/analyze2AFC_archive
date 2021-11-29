classdef twoChoiceTask
    %TASKOBJ Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % CONVENTIONS -- 
        % Stim in 1,2,3,4... (or float nnmbers)
        % Context in 1,2,3...
        % ResponsType in 0(miss), 1(correct), 2(incorrect)
        % Action - 0(no action), 1(choice 1), 2(choice 2)
        stimulus
        context 
        responseType
        action
        reward
        reactionTime
        accuracy
        acc1
        acc2
        % mouse name
        mouse
        % structure containing info about multiple days
        multiday 
        % structure containing info about object options
        ops
        
    end
    
    methods
        %-----------------------------CONSTRUCTOR METHODS-----------------------------------------
        function obj = twoChoiceTask(inStruct,varargin)
            %TASKOBJ Construct an instance of this class
            %   Detailed explanation goes here
            
            p = fn_inputParser(); p.parse(varargin{:});
            
            inputNames = fieldnames(inStruct);
            taskObjPropName = properties('twoChoiceTask');
            % WRITE variables into OBJ
            for i = 1:length(taskObjPropName)
                if contains(taskObjPropName{i},inputNames)
                   obj.(taskObjPropName{i}) = inStruct.(taskObjPropName{i});
                end 
            end
            
            if strcmp(p.Results.inputType,'cell')
                % WRITE 
                obj.multiday.multidayType = 'cell';
                obj.multiday.missType = 'keep';
                obj.multiday.dayLen = cellfun(@length, obj.action)';
                obj.multiday.dayLenNoMiss = cellfun(@(x)(sum(x~=0)), obj.action)';

                obj.ops.verbose = p.Results.verbose;
                obj.ops.learningCurveBin = p.Results.learningCurveBin;

                if strcmp(p.Results.multidayType,'matByTrial'); obj = concatenateDay(obj); end
                if strcmp(p.Results.missType,'remove'); obj = removeMiss(obj); end
            end
            
            function p = fn_inputParser()
                p = inputParser;
                p.KeepUnmatched = true;
                p.addParameter('inputType', 'cell')
                p.addParameter('multidayType', 'cell')
                p.addParameter('missType', 'keep')
                p.addParameter('learningCurveBin', 50)
                p.addParameter('verbose', true)
            end
            
        end
        %-----------------------------METHODS SPECIFIC TO TWOCHOICE TASK-----------------------------------------
        function obj = selectDay(obj,dayFlag)
            if strcmp(obj.multiday.multidayType,'cell')
                obj = fn_readStructBySelection(obj,'selectFlag',dayFlag);
                obj.multiday.dayLen = obj.multiday.dayLen(dayFlag);
                obj.multiday.dayLenNoMiss = obj.multiday.dayLenNoMiss(dayFlag);
            end  
        end
        
        function obj = concatenateDay(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            if strcmp(obj.multiday.multidayType,'cell')
                propCell = properties('twoChoiceTask');
                for i = 1:length(propCell)
                    if iscell(obj.(propCell{i})); obj.(propCell{i}) = fn_cell2mat(obj.(propCell{i}),1);end
                end
                obj.multiday.multidayType = 'matByTrial';
            else; msgbox(['Multiday type is ' obj.multiday.multidayType ', need to be cell'], 'ERROR MESSAGE');
            end
        end
        
        function [obj,missFlag] = removeMiss(obj)
            if strcmp(obj.multiday.multidayType,'matByTrial') && strcmp(obj.multiday.missType,'keep')
                missFlag = obj.action==0;               
                obj = fn_objfun(@(x)fn_removeIdx(x,missFlag),obj,'verbose',obj.ops.verbose);
            else
                msgbox(['Multiday type is ' obj.multiday.multidayType ', need to be mat; '... 
                    'Miss type is ' obj.multiday.missType ', need to be keep'], 'ERROR MESSAGE');
            end 
            obj.multiday.missType = 'remove';
        end
        
        function obj = getAcc(obj)
            switch obj.multiday.multidayType
                case 'matByTrial'; obj.accuracy = smoothdata(obj.responseType==1,'movmean',obj.ops.learningCurveBin);
                case 'cell'; 
            end
        end
        
        function [obj,bias] = getChoiceAcc(obj)
            [bias,obj.acc1,obj.acc2] = fn_getBias(obj.stimulus,obj.responseType,obj.ops.learningCurveBin);
        end
    end
end

