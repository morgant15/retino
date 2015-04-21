function res = loop_trials(exp, psy)
%LOOP_TRIALS does what it says

try
    % first, load the trial order
    fid = fopen(exp.run.trial_order_fn, 'r');
    header = textscan(fid, exp.cfg.csv_struct, 1, 'delimiter', ',');
    header = horzcat(header{:});
    blockInfo = textscan(fid, exp.cfg.csv_struct, 'delimiter', ',');
    blockInfo = horzcat(blockInfo{:});
    fclose(fid);
    
    % prepare a cell containing the field names that will be used as fieldnames
    % for cues and targets
    cues = blockInfo{:, exp.cfg.cue_col};
    targets = blockInfo{:, exp.cfg.targets_col};
    field_cues = regexp(cues, '[A-Za-z0-9_-]+', 'match', 'once');
    field_targets = regexp(targets, '[A-Za-z0-9_-]+', 'match', 'once');
    % display some greetings here
    
    ntrials = length(blockInfo);
    rts = zeros([ntrials, 1]);
    response = zeros([ntrials, 1]);
    % loop through trials
    for itrial = 1:length(blockInfo)
        % 1. fixation
        draw_fixation_circle(psy.expWin, psy.rect_fix)
        
        % 2. cue
        
        % 3. delay
        
        % 4. target
        
        % 5. fixation and wait for response
    end
catch
end

end