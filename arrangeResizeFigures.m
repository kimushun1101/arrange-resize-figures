function arrangeResizeFigures(options)
%  ARRANGERESIZEFIGURES arrangeResizeFigures(options) resize and arrange the figure in a grid to fit 
% the display.
%% ARGUMENTS
% options: 
%% 
% * |Figures: Array of figures to be applied.|
% * |Division: Number of horizontal and vertical divisions.|
% * |Monitor: Monitor number to display.|
% * |ExportDir: Save figures into ExportDir, if ExportDir is not "Display only".|
% * |ExportParams: export figures' parameters.|
%% EXAMPLES
% One line examples:
%%
% 
%   >> % Prepare some figures. 
%   >> % Prepare options.
%   >> figs = [figure(1), figure(3), figure(5)];
%   >> params.LineWidth = 5;
%   >> params.MarkerSize = 30;
%   >> 
%   >> % Excute samples. 
%   >> arrangeResizeFigures
%   >> arrangeResizeFigures()
%   >> arrangeResizeFigures(FigureList=figs)
%   >> arrangeResizeFigures(Division=[4,3])
%   >> arrangeResizeFigures(Monitor=2)
%   >> arrangeResizeFigures(ExportDir="fig")
%   >> arrangeResizeFigures(ExportParams=params)
%   >> arrangeResizeFigures(Figures=figs, Division=[4,3], Monitor=2, ExportDir="fig", ExportParams=params)
%
%% 
% Sample scripts with some figures are <./sampleScript.m sampleScript.m> or 
% <./sampleLiveScript.mlx sampleLiveScript.mlx>
%% Website
% A more detailed description is available on GitHub : <https://github.com/kimushun1101/resize-and-arrange-figures 
% https://github.com/kimushun1101/resize-and-arrange-figures>
% 
% License
% 
% 
arguments
    options.FigureList (1,:) matlab.ui.Figure = matlab.ui.Figure.empty()
    options.Division (1,2) {mustBeNumeric} = [3, 2] % horizontal, vertical
    options.Monitor (1,1) {mustBeNumeric} = 1 % to use second display
    options.ExportDir (1,1) string = "Display only"
    options.ExportParams (1,1) struct = struct()
end
%% For default arguments
% Set Figures
if numel(options.FigureList) > 0
    figures = options.FigureList;
else
    all_figures = findall(0,'Type','figure');
    notEmptyFigures = all_figures(~arrayfun(@(f) strcmp(f.Tag, 'EmbeddedFigure_Internal'), all_figures));
    [~, sortedIndices] = sort(arrayfun(@(f) f.Number, notEmptyFigures));
    figures = notEmptyFigures(sortedIndices);
end
%% 
% Check Display Number
DisplayNumMax = size(groot().MonitorPositions, 1);
if DisplayNumMax < options.Monitor
    DisplayNum = DisplayNumMax;
    warning('arrangeResizeFigures:incorrectNumber', ...
        "Display %d is not recognized. " + ...
        "Instead, figures are arranged on Display %d.", ...
        "If you change the monitor connection after starting MATLAB, restart MATLAB." + ...
        options.Monitor, DisplayNumMax);
else
    DisplayNum = options.Monitor;
end
%% 
% Set ExportParams
ExportParams = options.ExportParams;
fields = {'WidthPixels', 'FontSize', 'FontName', 'LineWidth', 'MarkerSize'};
values = {3.5 * groot().ScreenPixelsPerInch, 10.0, 'Times New Roman', 1.5, 10}; % Basically follows IEEE format
for i = 1:numel(fields)
    if ~isfield(ExportParams, fields{i})
        ExportParams.(fields{i}) = values{i};
    end
end
UnsupportedParams = setdiff(fieldnames(ExportParams), fields);
if ~isempty(UnsupportedParams)
   warning('arrangeResizeFigures:ParamsNotSupported', ...
           "ExportParams [%s]: Not supported currently. " + ...
           "If you have any requests, please contact us via GitHub issues.", ...
           strjoin(string(cell2mat(UnsupportedParams)), ', '));
end
%% For setting parameters
% Calculate positions
stackOffset = [30 -30 0 0];
pMargin = [0 25 0 50]; % positionMargin
mPosition = groot().MonitorPositions(DisplayNum,:);
mPosition(3) = mPosition(3) - pMargin(3);
mPosition(4) = mPosition(4) - pMargin(4);
nDiv = options.Division;
fSize = [mPosition(3)/nDiv(1)-pMargin(1), mPosition(4)/nDiv(2)-pMargin(2)]; % figureSize
gridAmount = prod(nDiv);
positions = zeros(prod(nDiv), 4);
positions(:,1) = repmat(     (0:nDiv(1)-1).*(fSize(1)+pMargin(1)) + mPosition(1) + pMargin(3), 1, nDiv(2))';
positions(:,2) = repelem(flip(0:nDiv(2)-1).*(fSize(2)+pMargin(2)) + mPosition(2) + pMargin(4), 1, nDiv(1))';
positions(:,3) = repmat(fSize(1), [1, gridAmount])';
positions(:,4) = repmat(fSize(2), [1, gridAmount])';
%% 
% Calculate scaling
scaleRate = positions(1,3)/ExportParams.WidthPixels;
FigureParams = ExportParams;
for i = 1:numel(fields)
    ExportParamsValue = ExportParams.(fields{i});
    if isa(ExportParamsValue, "double")
        FigureParams.(fields{i}) = scaleRate * ExportParamsValue;
    end
end
%% 
% Set figures parameters
for nFig = 1:numel(figures)
    figure_ = figures(nFig);
    % Set figure Children (axes or legend)
    for NumFigureChildren = 1:numel(figure_.Children)
        % Set Axes
        if strcmp(figure_.Children(NumFigureChildren).Type, 'axes')
            axes_ = figure_.Children(NumFigureChildren);
            % Set Grid
            axes_.XGrid = "on";
            axes_.YGrid = "on";
            % Set Font
            axes_.FontName = FigureParams.FontName;
            axes_.FontSize = FigureParams.FontSize;
            axes_.XLabel.FontName = FigureParams.FontName;
            axes_.XLabel.FontSize = FigureParams.FontSize;
            axes_.XLabel.Interpreter = 'latex';
            axes_.YLabel.FontName = FigureParams.FontName;
            axes_.YLabel.FontSize = FigureParams.FontSize;
            axes_.YLabel.Interpreter = 'latex';
            axes_.ZLabel.FontName = FigureParams.FontName;
            axes_.ZLabel.FontSize = FigureParams.FontSize;
            axes_.ZLabel.Interpreter = 'latex';
            % Set LineWidth
            for NumAxesChildren = 1:numel(axes_.Children)
                if ismember(axes_.Children(NumAxesChildren).Type, {'line', 'parameterizedfunctionline'})
                    axes_.Children(NumAxesChildren).LineWidth = FigureParams.LineWidth;
                    axes_.Children(NumAxesChildren).MarkerSize = FigureParams.MarkerSize;
                end
            end
        end
        % Set Legend
        if strcmp(figure_.Children(NumFigureChildren).Type, 'legend')
            legend_ = figure_.Children(NumFigureChildren);
            legend_.FontName = FigureParams.FontName;
            legend_.FontSize = FigureParams.FontSize;
            legend_.Interpreter = 'latex';
        end
    end
    % Skip figures in LiveScripts
    if strcmp(figure_.Tag, 'EmbeddedFigure_Internal')
        continue
    end
    % Set Position
    figure(nFig);
    if nFig < gridAmount
        figure_.OuterPosition = positions(nFig,:);
    else
        figure_.OuterPosition = positions(end,:) + stackOffset*(nFig - gridAmount);
    end
    % Export PDF
    if strcmp(options.ExportDir, "Display only")
        continue
    elseif strcmp(options.ExportDir, "")
        exportDir = pwd();
    else
        exportDir = options.ExportDir;
        if not(exist(exportDir, 'dir'))
            mkdir(exportDir)
        end
    end
    if figure_.Name
        figName = figure_.Name;
    else
        figName = append('Figure', string(figure_.Number));
    end
    exportgraphics(figure_, append(exportDir, '/', figName, '.pdf'))
end
end