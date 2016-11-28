function fnout = save_res(exp, res)
    csvname = sprintf('%s_block%02d', exp.run.subid, exp.run.blocknr);
    
    fnout = fullfile(exp.dir.res, [csvname, '.csv']);
    cell2csv(fnout, res, ',');
    
    exp_out = strrep(fnout, '.csv', '_exp.mat');
    save(exp_out, '-struct', exp);
end

