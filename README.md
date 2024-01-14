# resize and arrange figures

The script resizes the MATLAB figures and arranges them in a grid on the monitor.
These figures can be exported in PDF format.
The exported figures should be in IEEE format.

## Installation

- File Exchange

- GitHub : Download or `git clone`, then `addpath "the directory"`
    

## Usage
There are no arguments that must be set.
```
resizeAndArrangeFigures
% or
% resizeAndArrangeFigures()
```

### Option settings
It can be executed with the following options (default values in parentheses).

- Figures (All figures): Array of figures to be applied.
- Division ([3, 2]): Number of horizontal and vertical divisions.
- Monitor (1) : Monitor number to display.
- ExportDir ("Display only"): Save figures into ExportDir, if ExportDir is not "Display only".
- ExportParams: export figures' parameters.
    The currently supported parameters are as follows.
    Default value conforms to [IEEE two-column format](https://journals.ieeeauthorcenter.ieee.org/create-your-ieee-journal-article/create-graphics-for-your-article/file-formatting/).
    - WidthPx (3.5 * 96)
    - FontSize (10.0)
    - FontName ('Times New Roman')
    - LineWidth (1.5)
    - MarkerSize (10)

    If you have any requests, please contact us via GitHub issues.


### Command examples

Basic
```
resizeAndArrangeFigures
% or
% resizeAndArrangeFigures()
```
Only the specified figures
```
resizeAndArrangeFigures(Figures=figs)
```
Numbers of screen divisions : [horizontal, vertical]
```
resizeAndArrangeFigures(Division=[4,3])
```
Monitor to be displayed
```
resizeAndArrangeFigures(Monitor=2)
```
Directory name of the export destination
```
resizeAndArrangeFigures(ExportDir='fig')
```
Multiple settings above
```
resizeAndArrangeFigures(Figures=figs, Division=[4,3], Monitor=2, ExportDir='fig')
```
Exported figure settings
```
% Prepare some figures. 
params.LineWidth = 5;
params.MarkerSize = 30;
resizeAndArrangeFigures(ExportParams=params)
```

## License
BSD 3-Clause License
