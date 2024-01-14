function resizeAndArrangeFigures(options)
%  RESIZEANDARRANGEFIGURES resizeAndArrangeFigures(options) resize and arrange the figure in a grid to 
% fit the display.
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
%   >> resizeAndArrangeFigures
%   >> resizeAndArrangeFigures()
%   >> resizeAndArrangeFigures(Figures=figs)
%   >> resizeAndArrangeFigures(Division=[4,3])
%   >> resizeAndArrangeFigures(Monitor=2)
%   >> resizeAndArrangeFigures(ExportDir='fig')
%   >> resizeAndArrangeFigures(Figures=figs, Division=[4,3], Monitor=2, ExportDir='fig')
%
%% 
% Setting ExportParams example:
%%
% 
%   >> % Prepare some figures. 
%   >> params.LineWidth = 5;
%   >> params.MarkerSize = 30;
%   >> resizeAndArrangeFigures(ExportParams=params)
%
%% 
% Sample script is <./sampleScript.m sampleScript.m> or <./sampleLiveScript.mlx 
% sampleLiveScript.mlx>
%% Website
% GitHub : <https://github.com/kimushun1101/resizeAndArrangeFigures https://github.com/kimushun1101/resizeAndArrangeFigures>
arguments
    options.Figures (1,:) matlab.ui.Figure = matlab.ui.Figure.empty()
    options.Division (1,2) {mustBeNumeric} = [3, 2] % horizontal, vertical
    options.Monitor (1,1) {mustBeNumeric} = 1 % to use second display
    options.ExportDir (1,1) string = "Display only"
    options.ExportParams (1,1) struct = struct()
end
%% For default arguments
% Set Figures
if numel(options.Figures) > 0
    figures = options.Figures;
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
    warning('resizeAndArrangeFigures:incorrectNumber', ...
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
fields = {'WidthPx', 'FontSize', 'FontName', 'LineWidth', 'MarkerSize'};
values = {3.5 * 96, 10.0, 'Times New Roman', 1.5, 10}; % Basically follows IEEE format
for i = 1:numel(fields)
    if ~isfield(ExportParams, fields{i})
        ExportParams.(fields{i}) = values{i};
    end
end
UnsupportedParams = setdiff(fieldnames(ExportParams), fields);
if ~isempty(UnsupportedParams)
   warning('resizeAndArrangeFigures:ParamsNotSupported', ...
           "ExportParams [%s]: Not supported currently. " + ...
           "If you have any requests, please contact us via GitHub issues.", ...
           strjoin(string(cell2mat(UnsupportedParams)), ', '));
end
%% For setting parameters
% Calculate positions
positionOffset = [30 -30 0 0];
HighDecrease = 100;
MonitorSize = groot().MonitorPositions(DisplayNum,:);
MonitorSize(4) = MonitorSize(4) - HighDecrease;
divNum = options.Division;
figureNumber = prod(divNum);
positions = zeros(prod(divNum), 4);
positions(:,1) = repmat((0:divNum(1)-1).*MonitorSize(3)/divNum(1) + MonitorSize(1), 1, divNum(2))';
positions(:,2) = repelem((divNum(2)-1:-1:0).*MonitorSize(4)/divNum(2) + MonitorSize(2) + HighDecrease, 1, divNum(1))';
positions(:,3) = repmat(MonitorSize(3)/divNum(1), [1, figureNumber])';
positions(:,4) = repmat(MonitorSize(4)/divNum(2), [1, figureNumber])';
%% 
% Calculate scaling
scaleRate = positions(1,3)/ExportParams.WidthPx;
FigureParams = ExportParams;
for i = 1:numel(fields)
    ExportParamsValue = ExportParams.(fields{i});
    if isa(ExportParamsValue, "double")
        FigureParams.(fields{i}) = scaleRate * ExportParamsValue;
    end
end
%% 
% Set figures parameters
for NumFig = 1:numel(figures)
    figure_ = figures(NumFig);
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
    if NumFig < figureNumber
        figure_.OuterPosition = positions(NumFig,:);
    else
        figure_.OuterPosition = positions(end,:) + positionOffset*(NumFig - figureNumber);
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