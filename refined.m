%%
%Resistojet Based calculator

%%
%CONVERSION 
psi_pa=6895;  %psi->Pa

%%
%CONSTANTS
g0=9.81;    %[m/s^2]

%%
%INPUT PARAMETERS
Pe=6895/2;   %half psi as [Pa]
Pc=(200:200:600).*psi_pa;   %Chamber Pressure
dP=(0.15:0.10:0.25);        %percent system pressure drop before hitting thrusters
T0=(1000:500:3000)+273;     %Stagnation temperature[degK]; STAR AM Resistojet paper
    T0=[25+273 500+273 T0]; %Add room temperature for conservative estimate
k=1.4;                      %Gamma values; cold gas for now
Rs=297;                     %NITROGEN; J/kgK
Cf=1.3;                     %Typical Cf; RPE ch. 3
nCf=.95;                    %Typical nCf
Isp_ppulsed=(.8:0.1:1.0);   %Pulsed ISP vs. SS Isp; yes they are related
T=.2:.05:.3;                %N Thrust
dv=(600:200:1800);          %delta-v required; min is some orbital injection max is satellite orbit around earth no return
tb=(3600*1000:3600*1000:3600*3000); %total burn-time; [s/h]*hours
tb_full=(0.8:0.1:1.0);      %percent of time at full throttle, full Isp
N_thrusters=[4 8];          %Number of resistojet thrusters
nT=(.8:.1:1.0);             %Thruster efficiency; RPE 19-3; function of electrical parameters ~.65-.9
I=12;                       %Current supplied[A]


%%
%Refined Input
INPUT_O=[];
for z=1:length(Pc)
    for y=1:length(dP)
        for x=1:length(T0)
            for w=1:length(k)
                for v=1:length(Rs)
                    for u=1:length(Cf)
                        for t=1:length(nCf)
                            for s=1:length(Isp_ppulsed)
                                for r=1:length(T)
                                    for q=1:length(dv)
                                        for p=1:length(tb)
                                            for o=1:length(tb_full)
                                                for n=1:length(N_thrusters)
                                                    for m=1:length(nT)
                                                        for l=1:length(I)
                                                            INPUT_O(end+1,:)=[Pc(z) dP(y) T0(x) k(w) Rs(v) Cf(u) nCf(t) Isp_ppulsed(s) T(r) dv(q) tb(p) tb_full(o) N_thrusters(n) nT(m) I(l)];
                                                            disp(strcat("INITIALIZING INPUT:",num2str(z)));
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

%%
%OUTPUT
for z=1:length(INPUT_O)
    Pi(z)=INPUT_O(z,1)/(1-INPUT_O(z,2));
    cstar(z)=sqrt(INPUT_O(z,4)*INPUT_O(z,5)*INPUT_O(z,3))/(INPUT_O(z,4)*(2/(INPUT_O(z,4)+1))^((INPUT_O(z,4)-1)/(2*(INPUT_O(z,4)-1))));
    mdot(z)=(INPUT_O(z,9))/(cstar(z)*INPUT_O(z,6)*INPUT_O(z,7));
    Isp_f(z)=(INPUT_O(z,9))/(mdot(z)*g0);         %FULL THROTTLE ISP
    Isp_p(z)=INPUT_O(z,8)*Isp_f(z);             %Pulsed ISP
    Isp(z)=(Isp_f(z)*INPUT_O(z,12)+(Isp_p(z)*(1-INPUT_O(z,12))));   %WEIGHTED AVERAGE ISP
    c(z)=g0*Isp(z);
    MR(z)=exp(INPUT_O(z,10)/c(z));
    mp(z)=mdot(z)*INPUT_O(z,11);
    m0(z)=(MR(z)*mp(z))/(MR(z)-1);
    mf(z)=m0(z)/MR(z);
    %Nozzle Calculations
    mdot_n(z)=mdot(z)/INPUT_O(z,13);    %mdot per thruster on board
    vt(z)=sqrt(((2*INPUT_O(z,4))/(INPUT_O(z,4)+1))*INPUT_O(z,5)*INPUT_O(z,3));    %Throat Velocity; [m/s]
    V1(z)=INPUT_O(z,5)*INPUT_O(z,3)/INPUT_O(z,1);   %Specific volume of chamber
    Vt(z)=V1(z)*((INPUT_O(z,4)/2)^(1/(INPUT_O(z,4)-1)));
    V2(z)=V1(z)*(INPUT_O(z,1)/Pe)^(1/INPUT_O(z,4));
    At(z)=(mdot_n(z)*Vt(z))/vt(z);    %Throat Area
    ARat(z)=90;             %Area Ratio
    A2(z)=At(z)*ARat(z);    %Exit Area  
    Dt(z)=sqrt(At(z)/pi());
    D2(z)=sqrt(A2(z)/pi());
    %Electrical Power Calculations
    PF(z)=0.5*g0*Isp(z);                %Power to Thrust Ratio
    Pw(z)=(INPUT_O(z,9)*Isp(z)*g0)/(2*INPUT_O(z,14));   %Wattage required to achieve propulsion performance specs
    Vd(z)=Pw(z)/INPUT_O(z,15);                   %Voltage[V] drop across heating element required; assuming no losses across supply
    R(z)=Vd(z)/INPUT_O(z,15);                    %Resistance[Ohms] of heating element
    %Consolidate all data
    OUTPUT_O(z,:)=[Pi(z) cstar(z) mdot(z) Isp_f(z) Isp_p(z) Isp(z) c(z) MR(z) mp(z) m0(z) mf(z) mdot_n(z) vt(z) V1(z) Vt(z) V2(z) At(z) ARat(z) A2(z) Dt(z) D2(z) PF(z) Pw(z) Vd(z) R(z)];
    disp(strcat("CALCULATING OUTPUT:",num2str(z)));
end
header={'Pc[Pa]','dP[Pa]','T0[s]','gamma[-]','Rs[J/kgK]','Cf[-]','nCf[-]','Isp_pp[kg]','T[N]','dV[m/s]','burn-time[s]','burn-time_full[%]','#Thrusters[-]','nThruster[-]','Current[A]',...  %15
        'Pi[Pa]','cstar[m/s]','mdot[kg/s]','Isp_full[s]','Isp_pulsed[s]','Isp[s]','ve[m/s]','MR[-]','Mp[kg]','M0[kg]','Mf[kg]',...                          %26
            'mdot_thruster[kg/s]','vt[m/s]','V1[m^3/kg]','Vt[m^3/kg]','V2[m^3/kg]','At[m^2]','Area Ratio[-]','A2[m^2]','Dt[m]','D2[m]','PF[W/N]','Pw[W]','Vd[V]','R[Ohm]'};         %40
io=horzcat(INPUT_O,OUTPUT_O);       
io=num2cell(io);
dat=vertcat(header,io);
varsbefore = who;               %// get names of current variables (note 1)

%%
%SAVE DATA
fprintf("Saving input data...\n");
save INPUT.mat INPUT_O
fprintf("Input data Saved.\n")
fprintf("Saving output data...\n")
save OUTPUT.mat OUTPUT_O
fprintf("Output data Saved.\n")
fprintf("Consolidating data...\n")
save dat.mat dat
fprintf("Finished.\n")

tab=cell2table(dat(2:end,:),'VariableNames',header);

%writecell(dat,"REFINED_DATA.csv");