function tau = select_postseismic_tau(t, y, events, config)

if ~config.modelPostseismic || isempty(events.earthquake)
    tau = [];
    return
end

neq = numel(events.earthquake);
tau = nan(neq,1);

[G0, ~] = build_design_matrix(t, events, config, []);
m0 = G0 \ y;
baseRSS = sum((y - G0*m0).^2);

for i = 1:neq
    bestRSS = baseRSS;

    for tt = config.postseismicTauGrid
        testTau = nan(neq,1);
        testTau(i) = tt;

        [G, ~] = build_design_matrix(t, events, config, testTau);

        if rank(G) < size(G,2)
            continue
        end

        m = G \ y;
        rss = sum((y - G*m).^2);

        if rss < bestRSS
            bestRSS = rss;
            tau(i) = tt;
        end
    end
end

end