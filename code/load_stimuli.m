function [exp, psy] = load_stimuli(exp)
%LOAD_STIMULI starts psychtoolbox and performs some setup operations for the
%experiment, like loading textures and creating rects, and returns a structure
%psy containing the textures and the rects to be used later.
try
    PsychDefaultSetup(1);
    screens = Screen('Screens');
    if exp.cfg.debug
        screenNumber = max(screens);
    else
        screenNumber = min(screens);
    end
    
    % open screen
    exp.screen.old_res = SetResolution(screenNumber, ...
                                       exp.screen.resolution(1), ...
                                       exp.screen.resolution(2), ...
                                       exp.screen.resolution(3));
    [psy.expWin, psy.expRect] = PsychImaging('OpenWindow', screenNumber, ...
                                             exp.screen.bg_color);
    
    % get midpoints of screen
    [psy.mx, psy.my] = RectCenter(psy.expRect);
    
    % load stimuli file and add textures to the psy struct
    stimuli_fn = {'fam_cue', 'fam_tar', 'unk_cue', 'unk_tar'};
    nstimuli_fn = length(stimuli_fn);
    % make textures
    for i = 1:nstimuli_fn
       stimuli = txt2cell(exp.run.(stimuli_fn{i}));
       nstimuli = length(stimuli);
       for k = 1:nstimuli
          this_stim = stimuli{k};
          field_stim = this_stim(1:regexp(this_stim, '\.[A-Za-z]+')-1);
          
          img = imread(fullfile(exp.dir.stim, this_stim));
          psy.textures.(field_stim) = Screen('MakeTexture', psy.expWin, img);
       end
    end
    % make rects -- it's gonna be a cell where rows are the distances from
    % fixation and the columns are angles
    n_pos_deg = length(exp.stim.pos_deg);
    n_angles = round(2*pi/exp.stim.pos_rot);
    psy.rects = cell([n_pos_deg, n_angles]);
    centerRect = CenterRectOnPoint([0 0 exp.stim.size_pix], mx, my);
    for ipos = 1:n_pos_deg
        for kangle = 1:n_angles
            x_offset = round(exp.stim.pos_deg(ipos) * ...
                             cos((kangle-1)*exp.stim.pos_rot));
            y_offset = round(exp.stim.pos_deg(ipos) * ...
                             sin((kangle-1)*exp.stim.pos_rot));
            psy.rects{ipos, kangle} = ...
               CenterRectOnPoint(centerRect, psy.mx + x_offset, ...
                                 psy.my - y_offset);
        end
    end
catch
    ShowCursor;
    Screen('CloseAll');
    psychrethrow(psychlasterror);
    SetResolution(screenNumber, oldRes);
    ListenChar(0);
end
end

