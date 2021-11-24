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
        % mouse name
        mouse
        % structure containing info about multiple days
        multiday 
        % structure containing info about object options
        ops
        
    end
    
    methods
        %-----------------------------CONSTRUCTOR METHODS-----------------------------------------
        function obj = twoChoiceTask(inStruct)
            %TASKOBJ Construct an instance of this class
            %   Detailed explanation goes here
            inputNames = fieldnames(inStruct);
            taskObjPropName = properties('twoChoiceTask');
            % WRITE variables into OBJ
            for i = 1:length(taskObjPropName)
                if contains(taskObjPropName{i},inputNames)
                   obj.(taskObjPropName{i}) = inStruct.(taskObjPropName{i});
                end 
            end
            
            % WRITE 
            obj.multiday.multidayType = 'cell';
            obj.multiday.missType = 'keep';
            obj.multiday.dayLen = cellfun(@length, obj.action);
            obj.multiday.dayLenNoMiss = cellfun(@(x)(sum(x~=0)), obj.action);

            obj.ops.verbose = true;
            
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
                obj.multiday.multidayType = 'mat';
            else; msgbox(['Multiday type is ' obj.multiday.multidayType ', need to be cell'], 'ERROR MESSAGE');
            end
        end
        
        function obj = removeMiss(obj)
            if strcmp(obj.multiday.multidayType,'mat') && strcmp(obj.multiday.missType,'keep')
                missFlag = obj.action==0;               
                obj = fn_objfun(@(x)fn_removeIdx(x,missFlag),obj,'verbose',obj.ops.verbose);
            else
                msgbox(['Multiday type is ' obj.multiday.multidayType ', need to be mat; '... 
                    'Miss type is ' obj.multiday.missType ', need to be keep'], 'ERROR MESSAGE');
            end 
            obj.multiday.missType = 'remove';
        end
    end
end

