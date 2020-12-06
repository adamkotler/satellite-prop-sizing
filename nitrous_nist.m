%%
%Acquire NIST N2O data
set(0,'defaulttextinterpreter','latex') %Latex

p=150:50:800;
p_str={};
for z=1:length(p)
    p_str{z}=num2str(p(z));
end
t=readmatrix('nitrous-nist.xlsx','Sheet','150','Range','A1:A10');

c_v=[];
c_p=[];
k=[];
for z=1:length(p)
    c_v(:,z)=readmatrix('nitrous-nist.xlsx','Sheet',num2str(p(z)),'Range','H1:H10');
    c_p(:,z)=readmatrix('nitrous-nist.xlsx','Sheet',num2str(p(z)),'Range','I1:I10');
    k(:,z)=c_p(:,z)./c_v(:,z);
end

p_i=linspace(min(p),max(p),1000);
t_i=linspace(min(t),max(t),1000);
[p_i,t_i]=meshgrid(p_i,t_i);
k_i=interp2(p,t,k,p_i,t_i);

figure
set(gcf,'color',[1 1 1])
set(gcf,'DefaultLineLineWidth',1)
subplot(1,2,1)
surf(p,t,k)
colormap(summer)
title('Non-Interpolated')

subplot(1,2,2)
surf(p_i,t_i,k_i)
colormap(summer)
title('Interpolated')