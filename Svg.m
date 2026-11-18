classdef Svg < Figurehandler.FigureBase
    properties
        width = 31.56,
        height = 14.41, 
        font = "Arial";
        fontSize = 20,
        lineWidth = 3,
        markerSize = 8,
    end

    methods
        function obj = Svg(propArgs)
            arguments
                propArgs.?FigureBase
            end
            propertyCell = namedargs2cell(propArgs);
            obj@Figurehandler.FigureBase(propertyCell{:});
        end
    end

    methods (Access = protected)
        function CreateFile(obj, fig, path)
            if isempty(findall(fig, "Type", "Image"))
                exportgraphics(fig, strcat(path,'.svg'), 'ContentType','vector','BackgroundColor','white');
            else
                exportgraphics(fig, strcat(path,'.svg'), 'ContentType','image','BackgroundColor','white', "Resolution",600);
            end
        end
    end
end