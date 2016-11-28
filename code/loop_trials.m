function res = loop_trials(exp, psy)
%LOOP_TRIALS does what it says
spacebar_code = KbName('spacebar');

try
    % first, load the trial order
    fid = fopen(exp.run.trial_order_fn, 'r');
    header = textscan(fid, exp.csv.struct, 1, 'delimiter', ',');
    header = horzcat(header{:});
    blockInfo = textscan(fid, exp.csv.struct, 'delimiter', ',');
    blockInfo = horzcat(blockInfo{:});
    fclose(fid);

    % display some greetings here
    show_text(psy.expWin, exp.cfg.msg_start, 1);

    % loop through trials
    ntrials = length(blockInfo);
    rts = zeros([ntrials, 1]);
    response = zeros([ntrials, 1]);
    for itrial = 1:length(blockInfo)
        % get some info on this trial
        trial = blockInfo(itrial, :);
        % trial_pos = find(str2double(trial{exp.csv.pos_col}) == ...
        %    exp.stim.pos_deg);
        trial_angle = str2double(trial{exp.csv.angle_col});
        % 0. wait for subject's space bar
        wait_response(psy.expWin, psy.rect_fix, spacebar_code)
        % 1. fixation
        fixation(psy.expWin, psy.rect_fix, exp.time.fix_f);
        % 2. flash stimulus
        show_stim(psy.expWin, psy.textures.(field_targets{itrial}), ...
            psy.rects{trial_pos, trial_angle}, exp.time.stim_f);
        % 3. wait for response
        show_text(psy.expWin, exp.cfg.msg_response, 0)
        [rts(itrial), response(itrial)] = ...
            wait_response(psy.expWin, psy.rect_fix, exp.cfg.button_ids);
    end % for itrial

    % save results
    header_res = [header, 'rt', 'response'];
    res = [blockInfo, num2cell([rts, response])];
    res = [header_res; res];
catch exception
    cleanup(psy);
    throw(exception);
end
end

function show_text(expWin, msg, wait)
    Screen('TextSize', expWin, 18);
    DrawFormattedText(expWin, msg, 'center', 'center');
    Screen('Flip', expWin);
    if wait
      WaitSecs(1);
      KbWait([], 3);
      Screen('Flip', expWin);
    end
end % show_test

function fixation(expWin, rect_fix, duration_flip)
% draw fixation point for duration_flip
draw_fixation_circle(expWin, rect_fix);
Screen('Flip', expWin);
for kflip = 2:duration_flip
    draw_fixation_circle(expWin, rect_fix);
    Screen('Flip', expWin);
end
end % fixation

function show_stim(expWin, texture, rect, duration_flip)
Screen('DrawTexture', expWin, texture, rect);
Screen('Flip', expWin);
for kflip = 2:duration_flip
    Screen('DrawTexture', expWin, texture, rect);
    Screen('Flip', expWin);
end
end % show_stim

function [rt, response] = wait_response(expWin, rect_fix, button_ids)
fixation(expWin, rect_fix, 1);
[~, t0, keyCode] = KbCheck;
while ~any(keyCode(button_ids))
    fixation(expWin, rect_fix, 1);
    [~, RT, keyCode] = KbCheck;
end

rt = RT - t0;
response = find(keyCode);  % we'll figure out later
end
