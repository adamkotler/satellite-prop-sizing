function[PRAT_i,CF_i]=cfinterp()
%%
%Use to interpolate CF
PRAT=[1.8271 4 8 13.5 28.887 40.636 53.532 82.352 114.72];           %Pressure Ratio
Epsilon=[1 1.2583 1.8092 2.4702 4 5 6 8 10];                         %Area Ratio
CF=[.7060 1.0261 1.2107 1.3171 1.4383 1.4829 1.5153 1.5602 1.5907];  %PRAT, CF AND EPSILON MUST ALWAYS BE COUPLED!!!

PRAT_i=linspace(min(PRAT),max(PRAT),1000);
CF_i=interp1(PRAT,CF,PRAT_i,'pchip');
end