
close all

AIF = [565,612,549,638,558,576,591,506,604,520,558,574,488,596,533,618,591,965,2279,2917,3389,3647,3471,3174,2849,2431,2174,1970,1981,1999,2081,2034,2017,1954,1887,1810,1708,1653,1725,1762,1835,1850,1836,1847,1843,1867,1831,1768,1816,1807,1787,1838,1739,1763,1753,1690,1685,1699,1672,1634,1695,1644,1683,1653,1622,1674,1626,1640,1612,1635,1655,1667,1569,1615,1599,1632,1650,1590,1570,1559,1625,1586,1611,1614,1518,1535,1552,1536,1592,1549,1626,1537,1545,1500,1516,1478,1505,1479,1514,1439,1550,1502,1464,1513,1475,1507,1528,1487,1548,1455,1512,1448,1509,1498,1458,1525,1515,1450,1498,1490,1487,1474,1473,1400,1469,1442,1465,1470,1455,1451,1419,1486,1429,1477,1403,1406,1414,1442,1405,1475,1445,1433,1463,1367,1449,1406,1440,1450,1416,1361,1434,1372,1434,1420,1417,1460,1406,1460,1385,1434,1419,1405,1465,1361,1455,1387,1454,1393,1411,1335,1393,1410,1360,1432,1354,1450,1393,1438,1353,1366,1372,1353]; % An AIF signal from our dataset (could be replaced with any vascular input function)
figure, 
grid on 
plot(AIF)

bas = 10; % Baseline numbers
D = AIF ./ mean(AIF(1:bas)); % Calculate signal ratio curve

% Required parameters
FA = 14; % Flip angle (degree)
TR = 0.0027; % Repitition time (s)
weight = 75; % Patient weight (kg) Note: For standard dosage(0.1 mmol/kg), please set the patient weight equal to 75.
Hct = 0.45; % Hematocrit level 
r1 = 4.5; % Relaxivity of the used contrast agent (1/mM*s)
tem_res = 2; % Temporal resolution (s)
tt = 0:tem_res:tem_res*(numel(AIF)-1);

% Estimate percieved number of pulse
FittingParameters = EstimateNofPulses(D, FA, TR, Hct, r1, tt, weight); 
nPulse = FittingParameters.n;

% Correct AIF with estimated number of pulse
AIF_C = EstimateC(D, nPulse, Hct, FA, TR, r1); 