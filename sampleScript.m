%% Prepare some figures.
clear
close all

% To hide warnings on latex rendering
warning('off', 'MATLAB:handle_graphics:exceptions:SceneNode');
% warning('on')

x = 0:10;
y = [x; x.^2; sqrt(x); sin(x)];

figure(Name='liner');
plot(x, y(1,:));
xlabel('input $x$');
ylabel('output $y = x$');
legend('$x$');

figure(Name='quadratic');
plot(x, y(2,:),"LineStyle","--");
xlabel('input $x$');
% ylabel('output $y = x^2$');
legend('$x^2$', 'Location', 'northwest');

figure(Name='square root');
plot(x, y(3,:),"Marker","+");
% xlabel('input $x$');
ylabel('output $y = \sqrt{x}$');
legend('$\sqrt{x}$', 'Location', 'southeast');

figure(Name='sine curve');
plot(x, y(4,:), "Color", "#77AC30");
legend('$\sin{x}$', 'Location', 'southeast');

figure(Name='2 lines');
plot(x, y(3:4,:));
legend('$\sqrt{x}$', '$\sin{x}$', 'Location', 'northwest');

figure(Name='3 lines');
plot(x, y(1:3,:));

% figure(Name='4 lines');
figure;
plot(x, y([1, 3, 4],:));
xlabel('input $x$');
ylabel('outputs');
legend('$x$', '$\sqrt{x}$', '$\sin{x}$', 'Location', 'northwest');

%% Examples
% Prepare params option.
params.WidthInches = 7.0;
params.LineWidth = 3;
params.MarkerSize = 30;

% Execute samples
arrangeResizeFigures()
% arrangeResizeFigures(FigureNumbers=[2, 4, 6])
% arrangeResizeFigures(Division=[3,2])
% arrangeResizeFigures(PositionMargin=[50, 100, 25, 50])
% arrangeResizeFigures(Monitor=2)
% arrangeResizeFigures(ExportDir="fig")
arrangeResizeFigures(ExportParams=params)
% arrangeResizeFigures(FigureNumbers=figNums, Division=[4,3], PositionMargin=[50, 100, 25, 50], Monitor=2, ExportDir='fig', ExportParams=params)
