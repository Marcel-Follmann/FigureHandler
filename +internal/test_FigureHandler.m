classdef test_FigureHandler < matlab.unittest.TestCase

	properties
		figureHandler FigureHandler.Create
	end

	methods (TestClassSetup)

	end

	methods (TestMethodSetup)
		function InitFigureHandler(tc)
			tc.figureHandler = FigureHandler.Create("savePath"," ");
		end
	end

	methods (TestMethodTeardown)
		function deleteFigureHandler(tc)
			delete(tc.figureHandler);
		end
	end

	methods (Test)
		function testSurf_outOfBounds(tc)
			x = linspace(-.5*pi,.5*pi,100);
			y = x.'; 
			z = cos(x).*cos(y);

			fig = figure("Name", "Out of Bounds Test");
			tc.figureHandler.PrepareEmf(fig);
			surf(x, y, z);
			xlim([0,x(end)])
			set(gca, 'Clipping', 'on');
			set(findall(gca,'Type','Surface'), 'Clipping', 'on');
			
			tc.verfiyFormating(fig);
		end
	end

	methods
		function verfiyFormating(tc, fig)
			uiwait(fig); 

			choice = questdlg( ...
				"Formating correct?", ...
				"Visual Test", ...
				'Yes', 'No', 'Yes');

			tc.verifyEqual(choice, 'Yes', "Visual formating incorrect.");

			if ishandle(fig)
				close(fig);
			end
		end
	end

end