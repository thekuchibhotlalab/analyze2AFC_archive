classdef wheel2AFCmega < wheel2AFC
    %WHEEL2AFCMETA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    
    end
    
    methods
        function obj = wheel2AFCmega(objCell)
            %WHEEL2AFCMETA Construct an instance of this class
            %   Detailed explanation goes here
            
            S = combineObjProp(objCell);
            disp('a');
            obj = obj@wheel2AFC(S,'inputType','mat');
            
            function allStruct = combineObjProp(objCell)
                propCell = properties(objCell{1}); 
                for i = 1:length(propCell)
                    propName = propCell{i};

                    % cat all the arrays in the object
                    if isa(objCell{1}.(propName),'double') && size(objCell{1}.(propName),2)==1
                        tempProp = cellfun(@(x)(x.(propName)),objCell,'UniformOutput',false);
                        allStruct.(propName) = fn_cell2matFillNan(tempProp);
                    end

                    % cat all the structs in obj by each fieldname
                    if isstruct(objCell{1}.(propName))
                        try
                            tempCell = cellfun(@(x)(x.(propName)),objCell,'UniformOutput',false);
                            allStruct.(propName) =catMatInStruct(tempCell);
                        catch
                            disp(propName)
                        end
                    end

                end
                
            end

            function S = catMatInStruct(cellS)
                S = struct;
                fieldCell = fieldnames(cellS{1});
                for i = 1:length(fieldCell)
                    if isa(cellS{1}.(fieldCell{i}),'double')
                        try
                            tempCell = cellfun(@(x)(x.(fieldCell{i})),cellS,'UniformOutput',false);
                            S.(fieldCell{i}) = fn_cell2matFillNan(tempCell);
                        catch
                        end
                    end
                end

            end
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

