function [exp, psy] = load_stimuli(exp, psy)
%LOAD_STIMULI loads textures and creating rects, and returns a structure
%psy containing the textures and the rects to be used later.
try
    % load stimuli file and add textures to the psy struct
    stimuli_fn = {'fam_cue', 'fam_tar', 'unk_cue', 'unk_tar'};
    nstimuli_fn = length(stimuli_fn);
    % make textures
    for i = 1:nstimuli_fn
       stimuli = txt2cell(exp.run.(stimuli_fn{i}));
       nstimuli = length(stimuli);
       for k = 1:nstimuli
          this_stim = stimuli{k};
          field_stim = regexp(this_stim, '[A-Za-z0-9_-]+', 'match', 'once');
          
          img = imread(fullfile(exp.dir.stim, this_stim));
          psy.textures.(field_stim) = Screen('MakeTexture', psy.expWin, img);
       end
    end
    % make rects -- it's gonna be a cell where rows are the distances from
    % fixation and the columns are angles
    n_pos_deg = length(exp.stim.pos_deg);
    n_angles = round(2*pi/exp.stim.pos_rot);
    psy.rects = cell([n_pos_deg, n_angles]);
    centerRect = CenterRectOnPoint([0 0 exp.stim.size_pix], psy.mx, psy.my);
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
    % make rect for fixation
    psy.rect_fix = CenterRectOnPoint([0 0 exp.stim.fixcross_size_pix], ...
        psy.mx, psy.my);
catch
    ShowCursor;
    Screen('CloseAll');
    psychrethrow(psychlasterror);
    SetResolution(screenNumber, exp.screen.old_res);
    ListenChar(0);
end
end

