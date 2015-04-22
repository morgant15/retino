function cleanup(varargin)
if nargin == 2
    screenNumber = varargin{1};
    old_res = varargin{2};
end
ShowCursor;
Screen('CloseAll');
psychrethrow(psychlasterror);
if nargin == 2
    SetResolution(screenNumber, old_res);
end
ListenChar(0);
