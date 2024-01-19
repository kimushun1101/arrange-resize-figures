# arrange resize figures

The MATLAB function script arranges and resizes the figures in a grid on the monitor.

![example screenshot](./screenshot.png) 

It has the following features.
- Arrange figures on the grid according to the given vertical and horizontal numbers.
- Excess figures are stacked slightly off from the last figure position.
- The font size, line width, and marker size are resized according to the figure's width.
- These figures can be exported into PDF format.
- The exported figures conforms to IEEE format as default.

## Installation
There are two ways.
- File Exchange
- GitHub : Download or `git clone`, then copy `arrangeResizeFigures.mlx` into your workspace or `>> addpath('arrange-resize-figures')` in your MATLAB.
    

## Usage
There are no arguments that must be set.
The command is only `arrangeResizeFigures`.
See [the first example](#command-examples).

### Option settings
It can be executed with the following options (default values in parentheses).

- `FigureList` (All figures) : List of figures to be applied.
- `Division` ([3, 2]) : Number of horizontal and vertical divisions.
- `Monitor` (1) : Monitor number to display.
- `ExportDir` ("Display only") : Save figures into ExportDir, if ExportDir is not "Display only".
- `ExportParams` : export figures' parameters.
    The currently supported parameters are as follows.
    Default value conforms to [IEEE two-column format](https://journals.ieeeauthorcenter.ieee.org/create-your-ieee-journal-article/create-graphics-for-your-article/file-formatting/).
    - `WidthPx` (3.5 * 96)
    - `FontSize` (10.0)
    - `FontName` ("Times New Roman")
    - `LineWidth` (1.5)
    - `MarkerSize` (10)

If you have any requests, please contact us via [GitHub issues](https://github.com/kimushun1101/arrangeResizeFigures/issues).


### Command examples

After preparing some figures, run the following command or script.
A sample script including preparation is [sampleScript.m](https://github.com/kimushun1101/arrangeResizeFigures/blob/main/sampleScript.m).

Basic
```
arrangeResizeFigures
% or
% arrangeResizeFigures()
```
Only the specified figures
```
figs = [figure(1), figure(2)] % arbitrary figures
arrangeResizeFigures(FigureList=figs)
```
Numbers of screen divisions : [horizontal, vertical]
```
arrangeResizeFigures(Division=[4,3])
```
Monitor to be displayed
```
arrangeResizeFigures(Monitor=2)
```
Directory name of the export destination
```
arrangeResizeFigures(ExportDir='fig')
```
Exported figure settings
```
params.LineWidth = 5;
params.MarkerSize = 30;
arrangeResizeFigures(ExportParams=params)
```
Multiple of the above settings are made at the same time. It is also possible to give some of them.
```
arrangeResizeFigures(FigureList=figs, Division=[4,3], Monitor=2, ExportDir='fig', ExportParams=params)
```

## Tips

- A space is provided at the bottom of the set of arranged figures. You can click here to return the focus to MATLAB command window. See [the screenshot](#arrange-resize-figures).
- If you add a figure name, the file name will be used when the figure is exported to PDF format.
    ```
    figure(Name='liner');
    ```
    Otherwise, the file name will be "Figure" + figure.Number.
- To expose LiveScript figures outside, set the 'Visible' parameter to 'on'.
    ```
    figure(Name='liner', Visible='on');
    ```

## License
BSD 3-Clause License
