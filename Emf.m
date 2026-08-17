classdef Emf < base
    properties
        width = 31.56,
        height = 14.41, 
        font = "Arial";
        fontSize = 20,
        lineWidth = 3,
        markerSize = 8,
    end

    methods
        function obj = Emf(propArgs)
            arguments
                propArgs.?base
            end
            propertyCell = namedargs2cell(propArgs);
            obj@base(propertyCell{:});
        end
    end

    methods (Access = protected)
        function CreateFile(obj, fig, path)
            saveas(fig, strcat(path,'.emf'), 'meta');
        end
    end
end