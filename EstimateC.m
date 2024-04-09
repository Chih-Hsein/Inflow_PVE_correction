% This function calculates the AIF concentration with estimated perceived
% pulse number of protons in each measured time point. Accordingly, the 
% inflow and the partial volume effect would be compensated. 

function AIF_C = EstimateC(D_AIF, NPulse, Hct, FA, Tr, r1)

tic

nAIF = size(D_AIF, 1);
nTimePoint = size(D_AIF, 2);

AIF_C = zeros(size(D_AIF));

T10_re = 1/1.8;

E1 = @(T1_re) exp(-Tr .* T1_re);

Mz = @(T1_re, NPulse) (1 - (1-E1(T1_re) ) ./ (1-cosd(FA) * E1(T1_re) )) .* (cosd(FA) * E1(T1_re)) .^NPulse + (1-E1(T1_re)) ./ (1-cosd(FA)*E1(T1_re));

nPart = 1;
vPart = DecomposeIntoSeveralParts(nAIF, nPart);

disp('Analyzing AIFs...')

for iPart = 1 : nPart
    disp([num2str(iPart) ' / ' num2str(nPart)])
    
    parfor iAIF = vPart(1, iPart) : vPart(2, iPart)
        D_AIF_temp = D_AIF(iAIF, :);
        
        for i = 1 : nTimePoint
            AIF_C(iAIF, i) = fzero(@(C) Mz(T10_re + (1-Hct).* r1 * C, NPulse(iAIF)) ./ Mz(T10_re, NPulse(iAIF)) - D_AIF_temp(i), D_AIF_temp(i));
            
        end
    end
end

toc
end

function vPart = DecomposeIntoSeveralParts(nPoint, nPart)

    interval = ceil(nPoint / nPart);
    vPart_temp = 1 : interval : nPoint;
    vPart = [vPart_temp; vPart_temp(2:end)-1 nPoint];

end