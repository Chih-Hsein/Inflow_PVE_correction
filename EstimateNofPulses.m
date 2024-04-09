% This function estimating the perceived pulse nuber of inflow protons in
% blood was first designed by J.J.N van Schie in 2017 and was modified by C-H
% Tseng in 2022.
% Please refer to https://doi.org/10.1002/jmri.25906

function FittingParameters = EstimateNofPulses(D_AIF, FA, Tr, Hct, r1, tt, weight)
tic

nAIF = size(D_AIF, 1);
FittingParameters = zeros(nAIF, 5);

T10_re = 1/1.8; % The initial T1 time in blood is set to be 1.8 s.

% Orton's AIF model
AIF_Orton = @(aB, mB, aG, mG, t0, t) mB^2 * (...
    + (aB - aB*aG/(mB-mG)) *(t-t0) .*exp(-mB*(t-t0))...
    + aB*aG/(mB-mG)^2 * (exp(-mG*(t-t0)) - exp(-mB*(t-t0)))...
    ) .* double(t>t0);

E1 = @(T1_re) exp(-Tr .* T1_re);

Mz = @(n, T1_re) (1 - (1-E1(T1_re) ) ./ (1-cosd(FA) * E1(T1_re) )) .* (cosd(FA) * E1(T1_re)) .^n + (1-E1(T1_re)) ./ (1-cosd(FA)*E1(T1_re));

aB_fixed = 50.58*(75/weight); % for dose per body mass 0.1 mmole/kg, aB = 50.58 mmol*s/L, which scales linearly with dose per body mass

D = @(aB, mB, aG, mG, t0, n, t) Mz(n, T10_re + (1 - Hct) * r1 * AIF_Orton(aB, mB, aG, mG, t0, t)) ./ Mz(n, T10_re);
D_fixed = @(mB, aG, mG, t0, n, t) D(aB_fixed, mB, aG, mG, t0, n, t);

LB = [0, 0, 0, 0, 0];
UB = [1, 1, 1, Inf, Inf];
st = [0.2, 0.02, 0.002, 0, 20];

% from Orton's paper:
% mB = 0.2
% aG = 0.0207
% mG = 0.0028
% t0 = 6.24

s = fitoptions('Method','NonlinearLeastSquares','Lower',LB,'Upper',UB,'StartPoint',st);
f = fittype(D_fixed, 'independent','t','options',s);

disp('Analyzing AIFs...')

[c,gof,output] = fit(tt',D_AIF',f);
FittingParameters = c

% If fitting goes wrong at first, change start points and re-estimate
if gof.rsquare < 0.8
    st = [0.2, 0.2, 0.02, 0, 20];
    s = fitoptions('Method','NonlinearLeastSquares','Lower',LB,'Upper',UB,'StartPoint',st);
    f = fittype(D_fixed, 'independent','t','options',s);
    [c,gof,output] = fit(tt',D_AIF',f);
    FittingParameters = c
    if gof.rsquare < 0.8
        warning('Fail to estimate the pulse number!')
    end
end

   figure,
   plot(c, tt, D_AIF)
   xlim([0 tt(end)])

toc
end

