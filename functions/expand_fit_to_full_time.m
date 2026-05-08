function f = expand_fit_to_full_time(fSmall, tFull, keep, events, config, tau)

f = fSmall;

[Gfull, termsFull] = build_design_matrix(tFull, events, config, tau);

if ~isnumeric(Gfull)
    error('Gfull is %s, but it must be numeric.', class(Gfull));
end

if ~isnumeric(f.parameters)
    error('f.parameters is %s, but it must be numeric.', class(f.parameters));
end

f.fullTime = tFull(:);
f.fullG = Gfull;
f.fullTerms = termsFull;
f.fullModel = Gfull * f.parameters;

f.fullResidual = nan(size(tFull(:)));
f.fullResidual(keep) = fSmall.residual;

f.fullKeep = keep(:);

end