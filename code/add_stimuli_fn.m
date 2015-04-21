function exp = add_stimuli_fn(exp)
% LOAD_STIMULI_FN writes the stimuli fns to exp.run
% It requires the following structure for csv
% --- csv
%     |-- subid
%         |-- fam_cue.txt
%         |-- fam_tar.txt
%         |-- unk_cue.txt
%         |-- unk_tar.txt
% where fam_cue contains the picture names for the familiar cue
%       fam_tar contains the picture names for the familiar targets
%       unk_cue contains the picture names for the unknown cue
%       unk_tar contains the picture names for the unknown targets


fields = {'fam_cue', 'fam_tar', 'unk_cue', 'unk_tar'};
nfields = length(fields);

for i = 1:nfields
   exp.run.(fields{i}) = fullfile(exp.dir.csv, exp.run.subid, ...
                                  sprintf('%s_%s.txt', exp.run.subid, ...
                                          fields{i}));
end

exp.run.block_order_fn = fullfile(exp.dir.csv, exp.run.subid, ...
                                  sprintf('%s_blocks.txt', exp.run.subid));
                              
trial_orders = txt2cell(exp.run.block_order_fn);
exp.run.trial_order_fn = fullfile(exp.dir.csv, exp.run.subid, ...
                                  trial_orders{exp.run.blocknr});
end

