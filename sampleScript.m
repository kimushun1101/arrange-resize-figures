%% Prepare some figures.
clear
close all

% To hide warnings on latex rendering
warning('off', 'MATLAB:handle_graphics:exceptions:SceneNode');
% warning('on')

x = 0:10;
y = [x; x.^2; sqrt(x); sin(x)];

figs = matlab.ui.Figure.empty();    % for arguments

figure('Name', 'liner');
plot(x, y(1,:));
xlabel('input $x$');
ylabel('output $y = x$');
legend('$x$');
figs = [figs gcf];  % for arguments

figure('Name', 'quadratic');
plot(x, y(2,:),"LineStyle","--");
xlabel('input $x$');
% ylabel('output $y = x^2$');
legend('$x^2$', 'Location', 'northwest');

figure('Name', 'square root');
plot(x, y(3,:),"Marker","+");
% xlabel('input $x$');
ylabel('output $y = \sqrt{x}$');
legend('$\sqrt{x}$', 'Location', 'southeast');
figs = [figs gcf];  % for arguments

figure('Name', 'sine curve');
plot(x, y(4,:), "Color", "#77AC30");
legend('$\sin{x}$', 'Location', 'southeast');

figure('Name', '2 lines');
plot(x, y(3:4,:));
legend('$\sqrt{x}$', '$\sin{x}$', 'Location', 'northwest');
figs = [figs gcf];  % for arguments

figure('Name', '3 lines');
plot(x, y(1:3,:));

% figure('Name', '4 lines');
figure;
plot(x, y([1, 3, 4],:));
xlabel('input $x$');
ylabel('outputs');
legend('$x$', '$\sqrt{x}$', '$\sin{x}$', 'Location', 'northwest');

%% Examples
% resizeAndArrangeFigures()
resizeAndArrangeFigures(FigureList=figs)
% resizeAndArrangeFigures(Division=[4,3])
% resizeAndArrangeFigures(Monitor=2)
% resizeAndArrangeFigures(ExportDir='fig')
% resizeAndArrangeFigures(FigureList=figs, Division=[4,3], Monitor=2, ExportDir='fig')

% params.LineWidth = 5;
% params.MarkerSize = 30;
% resizeAndArrangeFigures(ExportParams=params)
