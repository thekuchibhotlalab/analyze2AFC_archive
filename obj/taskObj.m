classdef taskObj
    %TASKOBJ Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stimuli
        choice
        
    end
    
    methods
        function obj = taskObj(varargin)
            %TASKOBJ Construct an instance of this class
            %   Detailed explanation goes here
            p = fn_createTaskInputParser(varargin);
            inputNames = p.Results;
            
            
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

