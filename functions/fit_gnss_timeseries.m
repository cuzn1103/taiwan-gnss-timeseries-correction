function fit = fit_gnss_timeseries(series, events, config)

t = series.time(:);
Y.N = series.N(:);
Y.E = series.E(:);
Y.U = series.U(:);

keep = isfinite(t) & isfinite(Y.N) & isfinite(Y.E) & isfinite(Y.U);

tau.N = select_postseismic_tau(t(keep), Y.N(keep), events, config);
tau.E = select_postseismic_tau(t(keep), Y.E(keep), events, config);
tau.U = select_postseismic_tau(t(keep), Y.U(keep), events, config);

% ===== FIRST FIT =====
fN = fit_component(t(keep), Y.N(keep), events, config, tau.N);
fE = fit_component(t(keep), Y.E(keep), events, config, tau.E);
fU = fit_component(t(keep), Y.U(keep), events, config, tau.U);

disN = fN.residual;
disE = fE.residual;
disU = fU.residual;

% RMS sigma
sigmaN = sqrt(sum(disN.^2) / length(disN));
sigmaE = sqrt(sum(disE.^2) / length(disE));
sigmaU = sqrt(sum(disU.^2) / length(disU));

reject_local = abs(disE) > config.outlierSigma * sigmaE | ...
               abs(disN) > config.outlierSigma * sigmaN | ...
               abs(disU) > config.outlierSigma * sigmaU;

idx = find(keep);
reject = false(size(t));
reject(idx(reject_local)) = true;

keep(reject) = false;

% ===== FINAL FIT =====
fN = fit_component(t(keep), Y.N(keep), events, config, tau.N);
fE = fit_component(t(keep), Y.E(keep), events, config, tau.E);
fU = fit_component(t(keep), Y.U(keep), events, config, tau.U);

fit.keep = keep;
fit.N = expand_fit_to_full_time(fN, t, keep, events, config, tau.N);
fit.E = expand_fit_to_full_time(fE, t, keep, events, config, tau.E);
fit.U = expand_fit_to_full_time(fU, t, keep, events, config, tau.U);

fit.nOutliers = sum(~keep);

end