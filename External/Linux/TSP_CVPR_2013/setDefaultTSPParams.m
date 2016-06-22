function params = setDefaultTSPParams()
    params.cov_var_p = 1000;
    params.cov_var_a = 100;
    params.area_var = 400;
    params.alpha = -15;
    params.beta = -10;
    params.deltap_scale = 1e-3;
    params.deltaa_scale = 100;
    params.K = 200;
    params.Kpercent = 0.8;
    params.reestimateFlow = true;
end