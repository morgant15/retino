function experiment(subid, blocknr)
%EXPERIMENT runs the experiment for subid and blocknr
exp = struct();
exp.run.subid = subid;
exp.run.blocknr = blocknr;

% First, setup experimental variables, return a structure with the defaults
exp = setup_exp(exp);

% Then, start psychtoolbox
[exp, psy] = open_psychtoolbox(exp);
% load stimuli
[exp, psy] = load_stimuli(exp, psy);

% Then, loop through the trials
res = loop_trials(exp, psy);

% Save res and experiment details
fnout = save_res(exp, res);
fprintf('Saved results in %s\n', fnout);

% cleanup
cleanup(psy);
end
