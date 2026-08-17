classdef base < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        colorList
		lineStyleList
		interpreter
		savePath
    end

    properties (Access = private)
        paramList;
        figureList;
    end

    methods
        function obj = base(options)
            arguments
				options.colorList = ["#00934B", "#D37611", "#005287"];
				options.lineStyleList = ['-x'];
				options.interpreter = "latex";
				options.savePath (1,:) string {mustBeFolder} = " "
			end
            fn = fieldnames(options);
            for k=1:numel(fn), obj.(fn{k}) = options.(fn{k}); end

            set(groot, 'defaultTextInterpreter',obj.interpreter)
            obj.colorList = flip(obj.colorList);
        end

        function fig = Prepare(obj, fig, options)
            arguments
                obj,
                fig,
                options.width = NaN, 
                options.height = NaN,
                options.font = NaN,
                options.fontSize = NaN,
                options.lineWidth = NaN,
                options.markerSize = NaN,
                options.colorList = NaN,
            end

            fn = fieldnames(options);
            for k=1:numel(fn)
                if isnan(options.(fn{k})), options.(fn{k}) = obj.(fn{k}); end
            end

            fig = obj.FormatFigure(fig, options);
            obj.figureList = [obj.figureList, fig];		
            obj.paramList = [obj.paramList, options];
        end

        function GenerateOutputs(obj, options)
            arguments
                obj, 
                options.Symmetrical = false
            end
            obj.NormalizeSize(obj.figureList, obj.paramList, options.Symmetrical);
            for i = 1:numel(obj.figureList)
                % Prepare Save Path
                currentFigure = obj.figureList(i);
                figureName = regexprep(regexprep(lower(get(currentFigure,'Name')),' ', '_'),'-','_');
                figurePath = strcat(obj.savePath,figureName);

                % Generate Rectangle for propper cropping
                set(currentFigure,'Units', 'normalized');
                rect = annotation(currentFigure, 'rectangle',[0 0 1 1],'Color','w', 'LineWidth',1);

                obj.CreateFile(obj, currentFigure, figurePath)

                delete(rect);
            end
        end
    end

    methods (Access = private)
		function figure = FormatFigure(obj, figure, params)
			arguments
				obj,
				figure,
				params,
			end

			function SetAll(figure, property, value)
				objects = findall(figure, '-property', property);
				set(objects, property, value);
			end
			
			set(figure, "Color", "w");

			SetAll(figure, 'Units', 'Points');
			SetAll(figure, 'FontSize', params.fontSize);
			SetAll(figure, 'FontName', params.font);
			SetAll(figure, 'Interpreter', obj.interpreter);
			SetAll(figure, 'TickLabelInterpreter', obj.interpreter);
			SetAll(figure, 'ClippingStyle', 'rectangle');
			SetAll(figure, 'XMinorTick', 'on');
			SetAll(figure, 'YMinorTick', 'on');
			SetAll(figure, 'YLimitMethod', 'padded');
			SetAll(figure, 'XLimitMethod', 'tight');
			SetAll(figure, 'AlignVertexCenters', 'on');

			% Set line color & line style
			
			axes = findall(figure,'Type', 'Axes');
            numberOfAxes = numel(axes);
            for j = 1:numberOfAxes
                lines = findall(axes(j),'Type', 'Line');
                numberOfLines = numel(lines);
                colorList = obj.CreateColorList(numberOfLines);
                for i = 1:numberOfLines
				    set(lines(i), 'Color', hex2rgb(colorList(i)));
				    set(lines(i), 'Linewidth', params.lineWidth);
				    set(lines(i), 'MarkerSize', params.markerSize);
	    
                    if ~isempty(lines(i).XData)
                        if(lines(i).XData(end) == axes(j).XLim(end))
	                        lines(i).MarkerIndices(end) = [];
                        end
                        
                        if(lines(i).XData(1) == axes(j).XLim(1))
	                        lines(i).MarkerIndices(1) = [];
                        end
                    end
			    end
            end
			

			

			
		end

		function colorList = CreateColorList(obj, listLength)
			% Calculate number of complete iterates
			paletteLength = numel(obj.colorList);
			shadingIterates = ceil(listLength / paletteLength);

			% Calculate shading step size
			maximalShadingFactor = .75; % 0: no shading | 1: full shade
			shadingStepFactor = maximalShadingFactor / shadingIterates;
			
			% Iterate over palette
			colorList = strings(7, listLength);
			for i = 1:listLength
				iteration = ceil(i/paletteLength);
				paletteIndex = mod(i-1,paletteLength)+1;
				baseColor = hex2rgb(obj.colorList(paletteIndex));

				% Increase shading with each new iterate
				shading = shadingStepFactor * (iteration-1);
				rgbShaded = baseColor * (1 - shading);
				colorList(i) = rgb2hex(rgbShaded);
			end
		end
	
		function NormalizeSize(obj, figList, paramList, makeSymmetric)
			% Go through all figures and find the minimum required space for
			% all
			numberOfFigures = numel(figList);
			margins = zeros(1, 4);
			for i = 1:numberOfFigures
				currentFigure = figList(i);
				currentParams = paramList(i);
				currentMargins = obj.ExtractMargins(currentFigure, currentParams);
				margins = max([margins; currentMargins]);
			end

			if makeSymmetric
				margins(1) = max([margins(1), margins(3)]);
				margins(3) = margins(1);
			end

			% Set all figures for this minimum required space
			for i = 1:numberOfFigures
				currentFigure = figList(i);
				currentAxes = findall(currentFigure, "Type", "Axes");
                if isempty(currentAxes)
                    currentAxes = findall(currentFigure, "Type", "PolarAxes");
                end
                if numel(currentAxes) > 1
                    currentAxes = findall(currentFigure, "Type", "tiledlayout");
                end
				currentParams = paramList(i);

				set(currentFigure,'Units', 'centimeters');
				currentFigure.Position = [currentFigure.Position(1), ...
					currentFigure.Position(2), ...
					currentParams.width, currentParams.height];

				set(currentAxes, 'Units', 'centimeters');
                
				currentAxes.InnerPosition = [margins(1), margins(2), ...
					currentParams.width - margins(1) - margins(3),...
					currentParams.height - margins(2) - margins(4)];

				LgndObj = findall(currentFigure, 'Type', 'Legend');
				if numel(LgndObj) > 0
					legend(currentAxes,"Location", LgndObj.Location);
				end
			end
		end

		function savePath = SelectSavePath(obj)
			currentPath = cd; 
			newPath = uigetdir(currentPath);
			savePath = erase(newPath, currentPath)+"\";
			savePath = eraseBetween(savePath,1,1);
			clipboard('copy', "'" +savePath+"'");
			fprintf("Copied Path:\n'%s'\ninto clipboard.\n\nPlease insert into constructor:\n... = FigureHandler(...,'savePath', '%s');\n", savePath, savePath);
		end

		function margins = ExtractMargins(obj, figureObj, params)
			% Returns the required figure margins as [left, bottom, right, top] in
			% centimeters.

			pointInCentimeter = 2.54/72;
			
			axesObj = findall(figureObj, 'Type', 'Axes');
            if isempty(axesObj)
                axesObj = findall(figureObj, 'Type', 'PolarAxes');
                margins = [0,0,0,0];
                textObj1 = text(0,0,"$" +string(axesObj.ThetaTick(1)) + " ^\circ$", 'FontSize', params.fontSize, 'FontName',params.font, 'Units','centimeters');
                margins(4) = textObj1.Extent(4);
                margins(2) = textObj1.Extent(4);
                delete(textObj1);
                return
            end
            cbObj = findall(figureObj, 'Type', 'ColorBar');
			% Compute left & bottom margins from labels
            
            boundTop = 0;
            boundRight = 0;
            for i = 1:numel(axesObj)
			    set(axesObj(i), 'Units','centimeters');
			    set(axesObj(i).XLabel, 'Units','centimeters');
			    set(axesObj(i).YLabel, 'Units','centimeters');
                marginLeft = abs(axesObj(i).YLabel.Extent(1));
			    marginBottom = abs(axesObj(i).XLabel.Extent(2));
                boundTop = max([boundTop, abs(axesObj(i).Position(2) + axesObj(i).Position(4))]);
                boundRight = max([boundRight, abs(axesObj(i).Position(1) + axesObj(i).Position(3))]);
            end

			% Compute right & top margins from ticks
            marginRight = 0;
            if ~isempty(cbObj)
                if ~isempty(cbObj.Layout)
                    if cbObj.Layout.Tile == "east"
                        set(cbObj, 'Units', 'centimeters');
                        [~, idx] = max(cellfun(@length, cbObj.TickLabels));
                        textObj1 = text(0,0, cbObj.TickLabels(idx), 'FontSize', params.fontSize, 'FontName',params.font, 'Units','centimeters');
                        textObj2 = text(0,0, cbObj.Label.String, 'FontSize', params.fontSize, 'FontName',params.font, 'Units','centimeters');
                        marginRight = cbObj.Position(1)-boundRight + cbObj.Position(3) + textObj1.Extent(3) + 1.5*textObj2.Extent(4);
			            delete(textObj1);
                        delete(textObj2);
                    else
                        textObj1 = text(0,0, cbObj.TickLabels(end), 'FontSize', params.fontSize, 'FontName',params.font, 'Units','centimeters');
                        marginRight = textObj1.Extent(3)/2;
                        delete(textObj1);
                    end
                end
            else
                for i = 1:numel(axesObj)
                    if ~isempty(axesObj(i).XTickLabel)
			            textObj = text(0,0, axesObj(i).XTickLabel(end), 'FontSize', params.fontSize, 'FontName',params.font, 'Units','centimeters');
			            marginRight = max([marginRight, textObj.Extent(3)/2]);
			            delete(textObj);
                    end
                end
            end

			marginTop = 0;
            if ~isempty(cbObj)
                if ~isempty(cbObj.Layout)
                    if cbObj.Layout.Tile == "north"
                        set(cbObj, 'Units', 'centimeters');
                        [~, idx] = max(cellfun(@length, cbObj.TickLabels));
                        textObj1 = text(0,0, cbObj.TickLabels(idx), 'FontSize', params.fontSize, 'FontName',params.font, 'Units','centimeters');
                        textObj2 = text(0,0, cbObj.Label.String, 'FontSize', params.fontSize, 'FontName',params.font, 'Units','centimeters');
                        marginTop = cbObj.Position(2)-boundTop + textObj1.Extent(4) + 1.5*textObj2.Extent(4) + cbObj.Position(4);
			            delete(textObj1);
                        delete(textObj2);
                    else
                        textObj1 = text(0,0, cbObj.TickLabels(end), 'FontSize', params.fontSize, 'FontName',params.font, 'Units','centimeters');
                        marginTop = textObj1.Extent(4)/2;
                        delete(textObj1);
                    end
                else
                    set(cbObj, 'Units', 'centimeters');
                    [~, idx] = max(cellfun(@length, cbObj.TickLabels));
                    textObj1 = text(0,0, cbObj.TickLabels(idx), 'FontSize', params.fontSize, 'FontName',params.font, 'Units','centimeters');
                    textObj2 = text(0,0, cbObj.Label.String, 'FontSize', params.fontSize, 'FontName',params.font, 'Units','centimeters');
                    % marginRight = cbObj.Position(3);
                    % marginRight = textObj1.Extent(3) + cbObj.Position(3);
                    marginRight = marginRight + textObj2.Extent(4);
                    delete(textObj1);
			        delete(textObj2);
                end
            else
                for i = 1:numel(axesObj)
                    if ~isempty(axesObj(i).YTickLabel)
			            textObj = text(0,0, axesObj(i).YTickLabel(end), 'FontSize', params.fontSize, 'FontName',params.font, 'Units','centimeters');
			            marginTop = max([marginTop, textObj.Extent(4)/2]);
			            delete(textObj);
                    end
                end
            end

			baseline = 3*pointInCentimeter;
			margins = [marginLeft, marginBottom, marginRight, marginTop] + baseline;
		end
	end

    methods (Abstract, Access = protected)
        CreateFile(obj, fig, path)
    end
end