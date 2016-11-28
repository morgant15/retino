function [exp, psy] = load_stimuli(exp, psy)
%LOAD_STIMULI loads textures and creating rects, and returns a structure
%psy containing the textures and the rects to be used later.
try
    % make textures
    psy.textures = {};
    psy.textures_name = {};
    
    % rename var for easy use
    morphs = exp.cfg.morphs;
    n_morphs = length(morphs);
    fn = exp.cfg.fn;
    for imorph = 1:n_morphs
       this_fn = sprintf(fn, morphs(imorph));
       img = imread(fullfile(exp.dir.stim, this_fn));
       psy.textures_name{imorph} = this_fn;
       psy.textures{imorph} = Screen('MakeTexture', psy.expWin, img);
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
    % center rect
    psy.center_rect = centerRect;
catch exception
    cleanup(psy, exception);
end
end
