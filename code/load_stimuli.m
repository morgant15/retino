function [exp, psy] = load_stimuli(exp)
%LOAD_STIMULI starts psychtoolbox and performs some setup operations for the
%experiment, like loading textures and creating rects

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
catch
end
    


end

