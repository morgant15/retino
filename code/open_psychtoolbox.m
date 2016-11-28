function [exp, psy] = open_psychtoolbox(exp)
% OPEN_PSYCHTOOLBOX open psychtoolbox and set ups default values
try
    PsychDefaultSetup(1);
    screens = Screen('Screens');
    screenNumber = min(screens);
    %if exp.cfg.debug
    %    screenNumber = min(screens);
    %else
    %    screenNumber = min(screens);
    %end
    psy.screen.number = screenNumber;
    
    % open screen
    psy.screen.old_res = SetResolution(screenNumber, ...
                                       exp.screen.resolution(1), ...
                                       exp.screen.resolution(2), ...
                                       exp.screen.resolution(3));
    [psy.expWin, psy.expRect] = PsychImaging('OpenWindow', screenNumber, ...
                                             exp.screen.bg_color);
    
    % get midpoints of screen
    [psy.mx, psy.my] = RectCenter(psy.expRect);
catch exception
    cleanup(psy);
    throw(exception);
end
end