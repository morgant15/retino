function make_csv(exp, cfg)

% cfg.subid = 'subid';
% cfg.cue_fam = 'subid_cue_fam.txt';
% cfg.cue_unk = 'subid_cue_unk.txt';
% cfg.tar_fam = 'subid_tar_fam.txt';
% cfg.tar_unk = 'subid_tar_unk.txt';
% cfg.angle_pos = 0:7;
% cfg.tar_pos = [2 4 7];
% cfg.nrep = 1;
% cfg.ntrials_block = 72;
% cfg.nblocks = 8;

% save some types
p = @(x) fullfile(exp.dir.csv, cfg.subid, x);

stimuli_types = {'cue_fam', 'cue_unk', 'tar_fam', 'tar_unk'};
nstimuli_types = length(stimuli_types);

for i = 1:nstimuli_types
    fns.(stimuli_types{i}) = txt2cell(p(cfg.(stimuli_types{i})));
    nfns.(stimuli_types{i}) = length(fns.(stimuli_types{i}));
end


header = {'ntrl', 'cue', 'target', 'angle', 'eccentricity', ...
          'familiar', 'match'};
      
ntrials_complete = ((nfns.cue_fam + nfns.cue_unk) * ...
                    (nfns.tar_fam + nfns.tar_unk)) * cfg.nrep;
      
% check the math is right
if rem(ntrials_complete, cfg.ntrials_block) ~= 0
   error('Cannot divide %d trials into blocks of %d trials.', ...
       ntrials_complete, cfg.ntrials_block);
elseif rem(cfg.nblocks, ntrials_complete/cfg.ntrials_block) ~= 0
   error('Cannot create %d blocks of %d trials.', ...
       cfg.nblocks, cfg.ntrials_block);
end


for i = 1 : cfg.nblocks
    block = cell([ntrials_complete, length(header)]);
end
    