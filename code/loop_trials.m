function res = loop_trials(exp, psy)
%LOOP_TRIALS does what it says
spacebar_code = KbName('space');

morph_col = 2;
angle_col = 3;
% ecc_col = 4;

try
    % first, load the trial order
    block = make_block(exp.cfg);
    header = block(1, :);
    blockInfo = block(2:end, :);
   
    % reduce ntrials if debug
    if exp.cfg.debug 
        blockInfo = blockInfo(1:10, :);
    end
    
    % display some greetings here
    show_text(psy.expWin, exp.cfg.msg_start, 1);

    % loop through trials
    ntrials = length(blockInfo);
    rts = zeros([ntrials, 1]);
    response = zeros([ntrials, 1]);

    for itrial = 1:length(blockInfo)
        % get some info on this trial
        trial = blockInfo(itrial, :);
        % get field name to load texture
        this_fieldname = sprintf('t%03d', trial{morph_col});
        % trial_pos = find(str2double(trial{exp.csv.pos_col}) == ...
        %    exp.stim.pos_deg);
        trial_angle = trial{angle_col} + 1;
        % 0. wait for subject's space bar
        fixation(psy.expWin, psy.rect_fix, 0, spacebar_code)
        % 1. fixation 
            fixation(psy.expWin, psy.rect_fix, exp.time.fix_f);
        % 2. flash stimulus
        show_stim(psy.expWin, psy.textures.(this_fieldname), ...
            psy.rects{trial_angle}, exp.time.stim_f, exp.time.ifi);
        % 3. wait for response
        [rts(itrial), response(itrial)] = ...
            wait_response_text(psy.expWin, '', exp.cfg.button_ids);
    end % for itrial

    % convert buttons to button names
    response_label = cell(size(response));
    for i = 1:length(response)
       if response(i) == -1
           response_label{i} = 'reject';
       else
           response_label{i} = KbName(response(i));
       end
    end
    % save results
    header_res = [header, 'rt', 'response'];
    res = [blockInfo, num2cell(rts), response_label];
    res = [header_res; res];
catch exception
    %cleanup(psy);
    throw(exception);
end
end

function show_text(expWin, msg, wait)
    Screen('TextSize', expWin, 18);
    DrawFormattedText(expWin, msg, 'center', 'center', [255, 255, 255]);
    Screen('Flip', expWin);
    if wait
      WaitSecs(1);
      KbWait([], 3);
      Screen('Flip', expWin);
    end
end % show_test

function fixation(expWin, rect_fix, duration_flip, button_ids)
% draw fixation point for duration_flip
draw_fixation_circle(expWin, rect_fix);
Screen('Flip', expWin);
if duration_flip > 0
    for kflip = 2:duration_flip
        draw_fixation_circle(expWin, rect_fix);
        Screen('Flip', expWin);
    end
else
    [~, ~, keyCode] = KbCheck;
    while ~any(keyCode(button_ids))
        draw_fixation_circle(expWin, rect_fix);
        Screen('Flip', expWin);
        [~, ~, keyCode] = KbCheck;
    end
end
end % fixation

function show_stim(expWin, texture, rect, duration_flip, ifi)
Screen('DrawTexture', expWin, texture, [], rect);
vbl = Screen('Flip', expWin);
for kflip = 2:duration_flip
    Screen('DrawTexture', expWin, texture, [], rect);
    vbl = Screen('Flip', expWin, vbl + 0.5*ifi);
end
Screen('Flip', expWin, vbl + 0.5*ifi);
end % show_stim

function [rt, response] = wait_response_text(expWin, msg, button_ids)
DrawFormattedText(expWin, msg, 'center', 'center', [255, 255, 255]);
Screen('Flip', expWin);
[~, t0, keyCode] = KbCheck;
RT = t0;
while ~any(keyCode(button_ids))
    DrawFormattedText(expWin, msg, 'center', 'center', [255, 255, 255]);
    Screen('Flip', expWin);
    [~, RT, keyCode] = KbCheck;
end
rt = RT - t0;
response = find(keyCode);  % we'll figure out later

% if the subject pressed both buttons, then discard this
if length(response) == 2
   response = -1; 
end

Screen('Flip', expWin);
end
