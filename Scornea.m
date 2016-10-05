function [S, M, L] = Scornea(lmaxS, lmaxM, lmaxL)
% Calculate sensitivity at cornea

lmaxS =lmaxS;
lmaxM =lmaxM;
lmaxL =lmaxL;

Illumination = xlsread('Illumination2');
% Load illumination [(:,4):D65, (:,6):overcast_open_noon SantaRosa, (:,7):overcast_shaded_morning SantaRosa,(:,8):ss_closed_morning SantaRosa]
I = Illumination(:,7);
% Load macular pigment and lens [presnet: Illuminaiton(:,2), none: Illumination(:,3), only macular: Illumination(:,9), only lens: Illumination(:,10)]
macular_lens = Illumination(:,10);

% Calculate pigment sensitivity alpha band
x = [400:700]';
xS = lmaxS./x;
xM = lmaxM./x;
xL = lmaxL./x;

A = 69.7;
B = 28;
C = -14.9;
D = 0.674;
aS = 0.8795 + 0.0459*exp(-(lmaxS - 300)^2/11940);
aM = 0.8795 + 0.0459*exp(-(lmaxM - 300)^2/11940);
aL = 0.8795 + 0.0459*exp(-(lmaxL - 300)^2/11940);

b = 0.922;
c = 1.104;

ES = aS-xS;
EM = aM-xM;
EL = aL-xL;

FS = b-xS;
FM = b-xM;
FL = b-xL;

GS = c-xS;
GM = c-xM;
GL = c-xL;

HS = exp(A.*ES);
HM = exp(A.*EM);
HL = exp(A.*EL);

IS = exp(B.*FS);
IM = exp(B.*FM);
IL = exp(B.*FL);

JS = exp(C.*GS);
JM = exp(C.*GM);
JL = exp(C.*GL);

KS = HS+IS+JS+D;
KM = HM+IM+JM+D;
KL = HL+IL+JL+D;

Sa = 1./KS;
Ma = 1./KM;
La = 1./KL;

% Calculation pigment sensitivity beta band
Ab =0.26;

lmbS = 189 + 0.315*lmaxS; 
lmbM = 189 + 0.315*lmaxM; 
lmbL = 189 + 0.315*lmaxL;

bS = -40.5 + 0.195*lmaxS;
bM = -40.5 + 0.195*lmaxM;
bL = -40.5 + 0.195*lmaxL;

LS = x-lmbS;
LM = x-lmbM;
LL = x-lmbL;

Sb = Ab*exp(-(LS/bS).^2);
Mb = Ab*exp(-(LM/bM).^2);
Lb = Ab*exp(-(LL/bL).^2);

% Pigment sensitivity 
Sp = Sa + Sb;
Mp = Ma + Mb;
Lp = La + Lb;

% Pigment sensitivity at retina
Sr = 1-10.^((-0.3).*Sp);
Mr = 1-10.^((-0.3).*Mp);
Lr = 1-10.^((-0.3).*Lp);

% Pigment sensitivity at cornea
Sc = Sr.*10.^(-macular_lens);
Mc = Mr.*10.^(-macular_lens);
Lc = Lr.*10.^(-macular_lens);

% Pigment sensitivity under forest illumination
Si= Sc.*I;
Mi= Mc.*I;
Li= Lc.*I;

% Qunatum catch under flat illumination
QSi = sum(Si);
QMi = sum(Mi);
QLi = sum(Li);

% Normalize Sc, Mc, Lc so that quantum catch for 100% reflectance surface
% to be 1 under flat illumination
S = Sc./QSi;
M = Mc./QMi;
L = Lc./QLi;

