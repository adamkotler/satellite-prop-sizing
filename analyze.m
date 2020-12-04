close all;
%%
%ANALYZE DATA AFTER RUNNING REFINED
varsafter = [];
%%
%FIGURE 1: Isp vs. T_0; MULTIPLE: Chamber pressures
%Fix all other parameters besides Isp and T_0
Pc_t={[300*psi_pa] [500*psi_pa] [700*psi_pa]};      %chamber pressure_target
T_t={[.2] [.25] [.3]};%chamber pressure_target
T0_t={1500 2000 25000 3000};
for a=1:length(Pc_t)
    Pc_b{a}=INPUT_O(:,1)==400*psi_pa;
    dP_b{a}=INPUT_O(:,2)==0.15;
    Cf_b{a}=INPUT_O(:,6)==1.3;
    Isp_pp_b{a}=INPUT_O(:,8)==1.0;
    T_b{a}=INPUT_O(:,9)==T_t{a};
    dv_b{a}=INPUT_O(:,10)==1000;
    tb_b{a}=INPUT_O(:,11)==3600*1000;
    tb_full_b{a}=INPUT_O(:,12)==1.0;
    N_b{a}=INPUT_O(:,13)==4;
    f1_b{a}=horzcat(Pc_b{a},dP_b{a},Cf_b{a},Isp_pp_b{a},T_b{a},dv_b{a},tb_b{a},tb_full_b{a},N_b{a});  %Concatenate boolean vectors
    %Find all indices that satisfy all fixed parameters
    f1_idx{a}=[];
    for z=1:length(INPUT_O)
        if(sum(f1_b{a}(z,:))==9)
            f1_idx{a}(end+1)=z;
        end
    end
    %Consolidate output indices corresponding to variable x-axis and y-axis
    %targets
    x1{a}=[];
    y1{a}=[];
    for z=1:length(f1_idx{a})
        x1{a}(z)=dat{f1_idx{a}(z),3};       %Chamber Stagnation Temperature[degC]
        y1{a}(z)=dat{f1_idx{a}(z),19};      %Chamber ISP
    end
end

%%
%Plot data
%Isp Vs. Temperature
figure(1)
set(gcf,'defaultTextInterpreter','latex');
set(gcf,'color',[1 1 1])
set(gcf,'DefaultLineLineWidth',2)
set(gcf,'DefaultAxesFontSize',14)
for z=1:length(Pc_t)
    x1{z}=unique(x1{z});
    y1{z}=unique(y1{z});
    x1_temp{z}=x1{z}(1):1:x1{z}(end);
    y1{z}=interp1(x1{z},y1{z},x1_temp{z},'pchip');
    plot(x1_temp{z},y1{z},'b')
    hold on
end
grid on
grid minor
xlabel('Stagnation Temperature[$^{\circ} K$]')
ylabel(['$I_{sp}[s]$'])
title('Specific Impulse vs $T_{0}$ for GN2')
axis([x1{1}(1) x1{1}(end) y1{1}(1) y1{1}(end)])

%clear(varsnew{:})

%MR Vs. DeltaV; varied stagnation temperature
%FIGURE 2: Isp vs. wet mass; MULTIPLE: delta v
%Fix all other parameters besides Isp and T_0
for z=1:length(T0)
    T0_t{z}=T0(z);
end
system=struct;
for a=1:length(T0_t)
    Pc_b{a}=INPUT_O(:,1)==400*psi_pa;
    dP_b{a}=INPUT_O(:,2)==0.15;
    T0_b{a}=INPUT_O(:,3)==T0_t{a};
    Cf_b{a}=INPUT_O(:,6)==1.3;
    Isp_pp_b{a}=INPUT_O(:,8)==1.0;
    T_b{a}=INPUT_O(:,9)==.3;
    tb_b{a}=INPUT_O(:,11)==3600*1000;
    tb_full_b{a}=INPUT_O(:,12)==1.0;
    N_b{a}=INPUT_O(:,13)==4;
    f2_b{a}=horzcat(Pc_b{a},dP_b{a},T0_b{a},Cf_b{a},Isp_pp_b{a},T_b{a},tb_b{a},tb_full_b{a},N_b{a});  %Concatenate boolean vectors
    %Find all indices that satisfy all fixed parameters
    f2_idx{a}=[];
    for z=1:length(INPUT_O)
        if(sum(f2_b{a}(z,:))==9)
            f2_idx{a}(end+1)=z;
        end
    end
    
    %Consolidate output indices corresponding to variable x-axis and y-axis
    %targets
    dv2{a}=[];      %delta-v, figure 2
    MR2{a}=[];      %Mass Ratio, figure 2
    M02{a}=[];      %Wet Mass, figure 2
    Mp2{a}=[];      %Propellant Mass, figure 2
    Mf2{a}=[];      %Payload Mass, figure 2
    for z=1:length(f2_idx{a})
        dv2{a}(z)=dat{f2_idx{a}(z),10};      %Delta-V[kg]
        M02{a}(z)=dat{f2_idx{a}(z),25};      %wet mass[kg]
        Mf2{a}(z)=dat{f2_idx{a}(z),26};      %dry mass[kg]
        Mp2{a}(z)=dat{f2_idx{a}(z),24};      %propellant mass[kg]
        MR2{a}(z)=dat{f2_idx{a}(z),23};      %MR
    end
end

figure(2)
set(gcf,'defaultTextInterpreter','latex');
subplot(2,2,1)
set(gcf,'DefaultAxesFontSize',14)
set(gcf,'color',[1 1 1])
set(gcf,'DefaultLineLineWidth',2)
for z=1:length(T0_t)
    dv2_0{z}=dv2{z};
    dv2{z}=unique(dv2{z},'stable');
    MR2{z}=unique(MR2{z},'stable');
    dv2_temp{z}=dv2{z}(1):1:dv2{z}(end);
    MR2{z}=interp1(dv2{z},MR2{z},dv2_temp{z},'pchip');
    plot(dv2_temp{z},MR2{z})
    hold on
end
Leg=cell(length(T0_t),1);
for z=1:length(T0_t)
 Leg{z}=strcat(num2str(T0_t{z}-273),['[' char(176) 'C]']);
end
legend(Leg);
grid on
grid minor
xlabel('$\Delta V [\frac{m}{s}$]')
ylabel('MR[$\frac{M_{0}}{M_{f}}$]')
title('Vehicle Mass Ratio vs $\Delta V$')

subplot(2,2,2)
set(gcf,'color',[1 1 1])
set(gcf,'DefaultLineLineWidth',2)
for z=1:length(T0_t)
    Mf2{z}=unique(Mf2{z},'stable');
    Mf2{z}=interp1(dv2{z},Mf2{z},dv2_temp{z},'pchip');
    plot(dv2_temp{z},Mf2{z})
    hold on
end
Leg=cell(length(T0_t),1);
for z=1:length(T0_t)
 Leg{z}=strcat(num2str(T0_t{z}-273),['[' char(176) 'C]']);
end
legend(Leg);
grid on
grid minor
xlabel('$\Delta V[\frac{m}{s}]$')
ylabel('$M_{f}[kg]$')
title('Dry Mass vs $\Delta V$')

subplot(2,2,3)
set(gcf,'color',[1 1 1])
set(gcf,'DefaultLineLineWidth',2)
for z=1:length(T0_t)
    M02{z}=unique(M02{z},'stable');
    M02{z}=interp1(dv2{z},M02{z},dv2_temp{z},'pchip');
    plot(dv2_temp{z},M02{z})
    hold on
end
Leg=cell(length(T0_t),1);
for z=1:length(T0_t)
 Leg{z}=strcat(num2str(T0_t{z}-273),['[' char(176) 'C]']);
end
legend(Leg);
grid on
grid minor
xlabel('$\Delta V[\frac{m}{s}]$')
ylabel('$M_{0}[-]$')
title('Wet Mass vs $\Delta V$')

subplot(2,2,4)
set(gcf,'color',[1 1 1])
set(gcf,'DefaultLineLineWidth',2)
for z=1:length(T0_t)
    plot(dv2_0{z},Mp2{z})
    hold on
end
Leg=cell(length(T0_t),1);
for z=1:length(T0_t)
 Leg{z}=strcat(num2str(T0_t{z}-273),['[' char(176) 'C]']);
end
legend(Leg);
grid on
grid minor
xlabel('$\Delta V[\frac{m}{s}]$')
ylabel('$M_{p}[kg]$')
title('Propellant Mass vs $\Delta V$')

%FIGURE 3: R vs. nT; MULTIPLE: T0
%Fix all other parameters besides Isp and T_0
for z=1:length(dv)
    dV_t{z}=dv(z);
end
for a=1:length(dV_t)
    Pc_b{a}=INPUT_O(:,1)==400*psi_pa;
    dP_b{a}=INPUT_O(:,2)==0.15;
    Cf_b{a}=INPUT_O(:,6)==1.3;
    Isp_pp_b{a}=INPUT_O(:,8)==1.0;
    T_b{a}=INPUT_O(:,9)==.3;
    dV_b{a}=INPUT_O(:,10)==dV_t{a};
    tb_b{a}=INPUT_O(:,11)==3600*1000;
    tb_full_b{a}=INPUT_O(:,12)==1.0;
    N_b{a}=INPUT_O(:,13)==4;
    nT_b{a}=INPUT_O(:,14)==.9;
    f3_b{a}=horzcat(Pc_b{a},dP_b{a},Cf_b{a},Isp_pp_b{a},T_b{a},dV_b{a},tb_b{a},tb_full_b{a},N_b{a},nT_b{a});  %Concatenate boolean vectors
    %Find all indices that satisfy all fixed parameters
    f3_idx{a}=[];
    for z=1:length(INPUT_O)
        if(sum(f3_b{a}(z,:))==10)
            f3_idx{a}(end+1)=z;
        end
    end
    %Consolidate output indices corresponding to variable x-axis and y-axis
    %targets
    T03{a}=[];      %delta-v, figure 2
    R3{a}=[];      %Resistance, figure 2
    V3{a}=[];      %thruster efficiency, figure 2
    PF3{a}=[];      %Propellant Mass, figure 2
    Pw3{a}=[];      %Payload Mass, figure 2
    for z=1:length(f3_idx{a})
        T03{a}(z)=dat{f3_idx{a}(z),3};      %Delta-V[kg]
        R3{a}(z)=dat{f3_idx{a}(z),40};      %Resistance[kg]
        V3{a}(z)=dat{f3_idx{a}(z),39};      %Delta-V[kg]
        PF3{a}(z)=dat{f3_idx{a}(z),37};      %Delta-V[kg]
        Pw3{a}(z)=dat{f3_idx{a}(z),38};      %MR
    end
end
figure(3)
set(gcf,'defaultTextInterpreter','latex');
set(gcf,'DefaultAxesFontSize',14)
subplot(2,2,1)
set(gcf,'color',[1 1 1])
set(gcf,'DefaultLineLineWidth',2)
for z=1:length(dV_t)
    T03{z}=unique(T03{z},'stable');
    T03_temp{z}=T03{z}(1):1:T03{z}(end);
    R3{z}=interp1(T03{z},R3{z},T03_temp{z},'pchip');
    R3{z}=unique(R3{z},'stable');
    plot(T03_temp{z},R3{z})
    hold on
end
Leg=cell(length(dV_t),1);
for z=1:length(dV_t)
 Leg{z}=strcat(num2str(dV_t{z}),'[m/s]');
end
legend(Leg);
grid on
grid minor
xlabel(['$T_{0}[^{\circ}K]$'])
ylabel(['R[$\Omega$]'])
title('Element Resistance vs Stagnation Temperature')
axis([T03_temp{1}(1) T03_temp{1}(end) R3{z}(1) R3{z}(end)])

subplot(2,2,2)
set(gcf,'color',[1 1 1])
set(gcf,'DefaultLineLineWidth',2)
for z=1:length(dV_t)
    T03{z}=unique(T03{z},'stable');
    V3{z}=unique(V3{z},'stable');
    V3{z}=interp1(T03{z},V3{z},T03_temp{z},'pchip');
    plot(T03_temp{z},V3{z})
    hold on
end
Leg=cell(length(dV_t),1);
for z=1:length(dV_t)
 Leg{z}=strcat(num2str(dV_t{z}),'[m/s]');
end
legend(Leg);
grid on
grid minor
xlabel(['$T_{0}[^{\circ}K]$'])
ylabel(['$Volts[V]$'])
title('Nominal Voltage vs Stagnation Temperature')
axis([T03_temp{1}(1) T03_temp{1}(end) V3{z}(1) V3{z}(end)])

subplot(2,2,3)
set(gcf,'color',[1 1 1])
set(gcf,'DefaultLineLineWidth',2)
for z=1:length(dV_t)
    PF3{z}=unique(PF3{z},'stable');
    PF3{z}=interp1(T03{z},PF3{z},T03_temp{z},'pchip');
    plot(T03_temp{z},PF3{z})
    hold on
end
Leg=cell(length(dV_t),1);
for z=1:length(dV_t)
 Leg{z}=strcat(num2str(dV_t{z}),'[m/s]');
end
legend(Leg);
grid on
grid minor
xlabel('$T_{0}[^{\circ}K]$')
ylabel('P/F[$\frac{m}{s}$]')
title('Power-to-Thrust Ratio vs Stagnation Temperature')
axis([T03_temp{1}(1) T03_temp{1}(end) PF3{z}(1) PF3{z}(end)])

subplot(2,2,4)
set(gcf,'color',[1 1 1])
set(gcf,'DefaultLineLineWidth',2)
for z=1:length(dV_t)
    Pw3{z}=unique(Pw3{z},'stable');
    Pw3{z}=interp1(T03{z},Pw3{z},T03_temp{z},'pchip');
    plot(T03_temp{z},Pw3{z})
    hold on
end
Leg=cell(length(dV_t),1);
for z=1:length(dV_t)
 Leg{z}=strcat(num2str(dV_t{z}),'[m/s]');
end
legend(Leg);
grid on
grid minor
xlabel('$T_{0}[^{\circ}K]$')
ylabel('P[W]')
title('Nominal Heating Power vs Stagnation Temperature')
axis([T03_temp{1}(1) T03_temp{1}(end) Pw3{z}(1) Pw3{z}(end)])

%MR Vs. Temperautre; VARIED DeltaV
%FIGURE 4: Isp vs. wet mass; MULTIPLE: delta v
%Fix all other parameters besides Isp and T_0
for z=1:length(dv)
    dV_t{z}=dv(z);
end
for a=1:length(dV_t)
    Pc_b{a}=INPUT_O(:,1)==400*psi_pa;
    dP_b{a}=INPUT_O(:,2)==0.15;
    Cf_b{a}=INPUT_O(:,6)==1.3;
    Isp_pp_b{a}=INPUT_O(:,8)==1.0;
    T_b{a}=INPUT_O(:,9)==.3;
    dV_b{a}=INPUT_O(:,10)==dV_t{a};
    tb_b{a}=INPUT_O(:,11)==3600*1000;
    tb_full_b{a}=INPUT_O(:,12)==1.0;
    N_b{a}=INPUT_O(:,13)==4;
    f4_b{a}=horzcat(Pc_b{a},dP_b{a},Cf_b{a},Isp_pp_b{a},T_b{a},dV_b{a},tb_b{a},tb_full_b{a},N_b{a});  %Concatenate boolean vectors
    %Find all indices that satisfy all fixed parameters
    f4_idx{a}=[];
    for z=1:length(INPUT_O)
        if(sum(f4_b{a}(z,:))==9)
            f4_idx{a}(end+1)=z;
        end
    end
    %Consolidate output indices corresponding to variable x-axis and y-axis
    %targets
    T04{a}=[];      %delta-v, figure 2
    MR4{a}=[];      %Mass Ratio, figure 2
    M04{a}=[];      %Wet Mass, figure 2
    Mp4{a}=[];      %Propellant Mass, figure 2
    Mf4{a}=[];      %Payload Mass, figure 2
    for z=1:length(f4_idx{a})
        T04{a}(z)=dat{f4_idx{a}(z),3};       %Temperature[kg]
        M04{a}(z)=dat{f4_idx{a}(z),25};      %Delta-V[kg]
        Mf4{a}(z)=dat{f4_idx{a}(z),26};      %Delta-V[kg]
        Mp4{a}(z)=dat{f4_idx{a}(z),24};      %Delta-V[kg]
        MR4{a}(z)=dat{f4_idx{a}(z),23};      %MR
    end
end
figure(4)
set(gcf,'defaultTextInterpreter','latex');
set(gcf,'DefaultAxesFontSize',14)
subplot(2,2,1)
set(gcf,'color',[1 1 1])
set(gcf,'DefaultLineLineWidth',2)
hold on
for z=1:length(dV_t)
    T04{z}=unique(T04{z},'stable');
    MR4{z}=unique(MR4{z},'stable');
    T04_temp{z}=T04{z}(1):1:T04{z}(end);
    MR4{z}=interp1(T04{z},MR4{z},T04_temp{z},'pchip');
    plot(T04_temp{z},MR4{z})
    hold on
end
Leg=cell(length(dV_t),1);
for z=1:length(dV_t)
 Leg{z}=strcat(num2str(dV_t{z}),['[m/s]']);
end

grid on
grid minor
xlabel('$T_{0}[^{\circ}K]$')
ylabel('MR[-]')
title('Vehicle Mass Ratio vs $T_{0}$')
axis([min(T04{2}) max(T04{2}) min(MR4{2}) max(MR4{end})])

subplot(2,2,2)
set(gcf,'color',[1 1 1])
set(gcf,'DefaultLineLineWidth',2)
%plot(T04{1},Mf4{1},'.r')
hold on
for z=1:length(dV_t)
    Mf4{z}=unique(Mf4{z},'stable');
    Mf4{z}=interp1(T04{z},Mf4{z},T04_temp{z},'pchip');
    plot(T04_temp{z},Mf4{z})
    hold on
end
Leg=cell(length(dV_t),1);
for z=1:length(dV_t)
 Leg{z}=strcat(num2str(dV_t{z}),['[m/s]']);
end
legend(Leg);
grid on
grid minor
xlabel('$T_{0} [^{\circ}K]$')
ylabel('$M_{f}$[kg]')
title('Dry Mass vs $T_{0}$')
axis([min(T04{1}) max(T04{1}) min(Mf4{end}) max(Mf4{1})])

subplot(2,2,3)
set(gcf,'color',[1 1 1])
set(gcf,'DefaultLineLineWidth',2)
%plot(T04{1},M04{1},'.r')
hold on
for z=1:length(dV_t)
    M04{z}=unique(M04{z},'stable');
    M04{z}=interp1(T04{z},M04{z},T04_temp{z},'pchip');
    plot(T04_temp{z},M04{z})
    hold on
end
Leg=cell(length(dV_t),1);
for z=1:length(dV_t)
 Leg{z}=strcat(num2str(dV_t{z}),['[m/s]']);
end
legend(Leg);
% for z=1:length(dV_t)
%     plot(T04{z}(1:4),M04{z}(1:4),'.')
%     hold on
% end
grid on
grid minor
xlabel('$T_{0} [^{\circ}K]$')
ylabel('$M_{0}[kg]$')
title('Wet Mass vs $T_{0}$')
axis([min(T04{1}) max(T04{1}) min(M04{end}) max(M04{1})])

subplot(2,2,4)
set(gcf,'color',[1 1 1])
set(gcf,'DefaultLineLineWidth',2)
%plot(T04{1},Mp4{1},'.-r')
hold on
for z=1:length(dV_t)
    Mp4{z}=unique(Mp4{z},'stable');
    Mp4{z}=interp1(T04{z},Mp4{z},T04_temp{z},'pchip');
    plot(T04_temp{z},Mp4{z})
    hold on
end
Leg=cell(length(dV_t),1);
for z=1:length(dV_t)
 Leg{z}=strcat(num2str(dV_t{z}),['[m/s]']);
end
legend(Leg);
% for z=1:length(dV_t)
%     plot(T04{z}(1:4),Mp4{z}(1:4),'.')
%     hold on
% end
grid on
grid minor
xlabel('$T_{0} [^{\circ}K]$')
ylabel('$M_{p}[kg]$')
title('Propellant Mass vs $T_{0}$')
axis([min(T04{1}) max(T04{1}) min(Mp4{1}) max(Mp4{end})])