function fnout = save_res(exp, res)
    csvdir = fullfile(exp.dir.csv, exp.run.subid);
    csvname = strrep(exp.run.trial_order_fn, csvdir, '');
    
    fnout = fullfile(exp.dir.res, ['res_', csvname]);
    cell2csv(fnout, res, ',');
end

