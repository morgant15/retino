function cleanup(varargin)
if nargin == 1
    psy = varargin{1};
elseif nargin == 2
    psy = varargin{1};
    exception = varargin{2};
else
    error('Only a max of two args are permitted');
end

ShowCursor;
ListenChar();
Screen('CloseAll');
if nargin > 1
    SetResolution(psy.screen.number, psy.screen.old_res);
end
ListenChar(0);