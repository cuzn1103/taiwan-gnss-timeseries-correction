function f = fit_component(t, y, events, config, tau)

t = t(:);
y = y(:);

valid = isfinite(t) & isfinite(y);
t = t(valid);
y = y(valid);

[G, terms] = build_design_matrix(t, events, config, tau);

if ~isnumeric(G)
    error('G is %s, but it must be numeric. Check build_design_matrix output order.', class(G));
end

if size(G,1) <= size(G,2)
    error('Not enough data points: %d data for %d parameters.', size(G,1), size(G,2));
end

m = G \ y;

model = G * m;
residual = y - model;

sigma0 = sqrt(sum(residual.^2) / length(residual));

C = pinv(G' * G);
paramSigma = sqrt(max(diag(C),0)) * sigma0;

names = {terms.name};
linearIdx = strcmp(names, 'linear');

f.time = t;
f.G = G;
f.terms = terms;
f.parameters = m;
f.parameterSigma = paramSigma;
f.model = model;
f.residual = residual;
f.sigma0 = sigma0;
f.velocity = m(linearIdx);
f.velocitySigma = paramSigma(linearIdx);
f.tau = tau;

end