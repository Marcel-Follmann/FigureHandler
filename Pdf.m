classdef Pdf < Figurehandler.FigureBase
    properties
        width = 8.8,
        height = 8.8/1.618, 
        font = "Times New Roman";
        fontSize = 8,
        lineWidth = 1.5,
        markerSize = 3,
    end

    methods
        function obj = Pdf(propArgs)
            arguments
                propArgs.?Figurehandler.FigureBase
            end
            propertyCell = namedargs2cell(propArgs);
            obj@Figurehandler.FigureBase(propertyCell{:});
        end
    end

    methods (Access = protected)
        function CreateFile(obj, fig, path)
            if isempty(findall(fig, "Type", "Image"))
                exportgraphics(fig, strcat(path,'.pdf'), 'ContentType','vector','BackgroundColor','white');
            else
                exportgraphics(fig, strcat(path,'.pdf'), 'ContentType','image','BackgroundColor','white', "Resolution",600);
            end
        end
    end
end