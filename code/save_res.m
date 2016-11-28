function fnout = save_res(exp, res)
    t = datestr(now, 'yyyymmddTHHMMSS');
    csvname = sprintf('%s_block%02d', exp.run.subid, exp.run.blocknr);
    dirout = fullfile(exp.dir.res, exp.run.subid);
    if ~exist(dirout, 'dir')
        mkdir(dirout);
    end
    fnout = fullfile(dirout, [csvname, '_', t, '.csv']);
    cell2csv(fnout, res, ',');
    
    exp_out = strrep(fnout, '.csv', '_exp.mat');
    save(exp_out, '-struct', 'exp');
end

