%% Plot figures for the Proteus paper

colors1 = ["#89B0C1","#617192","#301131","#4D4262"];
colors2 = {'#000000','#652278','#CA6184','#D9601A','#E0C56C','#589E87','#4A747D'};
colors2 = {'#000000','#652278','#CA6184','#E8A82A','#C9C9C9','#589E87','#4A747D'};

%% U vs Qs - Figure 3
% Digitized data
Qs = [0 2 4 6]*1.6e-19/(9.0*8.9*1e-18);
Qs_digitized = [0, 0.0040, 0.0080, 0.0120];
U_digitized = [0.00504, 0.35294, 0.71092, 1.03866];

figure; hold on; box on 
set(gcf,'Units','centimeters','Position',[5 5 6 6])
plot(Qs, Qs./(1.135*1e-2),'Color',colors1{1})
plot(Qs,U_digitized,'o','MarkerSize',6,'Color',colors1{2},'MarkerFaceColor',colors1{1})
set(gca,'FontSize',9,'YColor','k','XColor','k')
set(gca,'YTick',0:0.4:1.2,'XTick',0:0.004:0.012)
xlabel('Qs / C m-2')
ylabel('U / V')
xlim([0 0.012]); ylim([0 1.2])
saveas(gcf,'Graph_UvsQs','pdf')

%% Capacitance values
fperox = [0, 12.5,29, 50, 100]'; % [%]
Cperox = [1.135, 1.162, 1.178, 1.285, 1.701]'; % [uF/cm^2]
fincr_perox = Cperox./Cperox(1);

fox = [0, 10, 20, 50]';
Cox = [0.82, 0.974, 1.02, 1.495]';
fincr_ox = Cox./Cox(1);

% % Linear fits 
% x = 0:1:100;
% F1 = fit(fperox, Cperox, 'poly1');
% fit1 = F1.p1*x + F1.p2;
% F2 = fit(fox, Cox, 'poly1');
% fit2 = F2.p1*x + F2.p2;

% quadratic fits
x = 0:1:100;
F1 = fit(fperox, Cperox, 'poly2');
fit1 = F1.p1*x.^2 + F1.p2*x + F1.p3;
F2 = fit(fox, Cox, 'poly2');
fit2 = F2.p1*x.^2 + F2.p2*x + F2.p3;

figure; hold on; box on
set(gcf,'Units','centimeters','Position',[5 5 8 6])
plot(fperox,Cperox,'s','MarkerSize',6,'Color',colors1{2},'MarkerFaceColor',colors1{1})
plot(fox,Cox,'o','MarkerSize',6,'Color',colors1{3},'MarkerFaceColor',colors1{4})
plot(x,fit1,':','Color',colors1{2})
plot(x,fit2,':','Color',colors1{3})
set(gca,'FontSize',9,'YColor','k','XColor','k')
xlabel('% oxidized lipids')
ylabel('Capacitance / \muF cm-2')
legend('primary','secondary','Location','SouthEast')
ylim([0.6 1.801])
saveas(gcf,'Graph_Capacitance','pdf')

figure; hold on; box on
set(gcf,'Units','centimeters','Position',[5 5 8 6])
plot(fperox,fincr_perox,'s','MarkerSize',6,'Color',colors1{2},'MarkerFaceColor',colors1{1})
plot(fox,fincr_ox,'o','MarkerSize',6,'Color',colors1{3},'MarkerFaceColor',colors1{4})
plot(x,fit1./fit1(1),':','Color',colors1{2})
plot(x,fit2./fit2(1),':','Color',colors1{3})
set(gca,'FontSize',9,'YColor','k','XColor','k')
xlabel('% oxidized lipids')
ylabel('fincrease = C/C0')
ylim([1 2])
saveas(gcf,'Graph_fincrease','pdf')

%% Change in Um due to chage in capacitance 
Urest = -0.07;
Um_perox = Urest./fincr_perox;
Um_ox = Urest./fincr_ox;
x = 0:1:100;
fit3 = Urest./(fit1./fit1(1));
fit4 = Urest./(fit2./fit2(1));

figure; hold on; box on
set(gcf,'Units','centimeters','Position',[5 5 8 6])
yyaxis left
plot(fperox,Um_perox*1e3,'s','MarkerSize',6,'Color',colors1{2},'MarkerFaceColor',colors1{1})
plot(fox,Um_ox*1e3,'o','MarkerSize',6,'Color',colors1{3},'MarkerFaceColor',colors1{4})
plot(x,fit3*1e3,':','Color',colors1{2})
plot(x,fit4*1e3,':','Color',colors1{3})
plot([0 100],[-55 -55],'k-')
set(gca,'FontSize',9,'YColor','k')
xlabel('% oxidized lipids')
ylabel('U / mV')
legend('primary','secondary','Location','SouthEast')
ylim([-80 -30])
yyaxis right
fincr_ticks = 1:0.2:2.2;
set(gca,'YTick',Urest*1e3./fincr_ticks,'YTickLabel',{'1','1.2','1.4','1.6','1.8','2','2.2'})
set(gca,'FontSize',9,'YColor','k')
ylim([-80 -30])
saveas(gcf,'Graph_APthreshold_U2','pdf')

%% EQUIVALENT CIRCUIT
% model = mphload('HHcircuit_CmGox.mph');
% % Respone to stimulus
% t1 = mphglobal(model,'t','dataset','dset5','outersolnum',1);
% data1 = mphglobal(model,'U','dataset','dset5','outersolnum','all');
% % Response to change in capacitance
% t2 = mphglobal(model,'t','dataset','dset12','outersolnum',1);
% data2 = mphglobal(model,'U','dataset','dset12','outersolnum','all');
% % Area fraction vs change in capacitance
% t3 = mphglobal(model,'t','dataset','dset14','outersolnum',1);
% data3 = mphglobal(model,'U','dataset','dset14','outersolnum','all');
% tmp = mphglobal(model,'increase','dataset','dset14','outersolnum','all');
% tmp2 = mphglobal(model,'area_ox','dataset','dset14','outersolnum','all');
% increase = tmp(1,1:8); 
% frac_ox = tmp2(1,1:8:end)./1000e-12;
% % Influence of tox - Capacitance only
% t8 = mphglobal(model,'t','dataset','dset28','outersolnum',1);
% data8 = mphglobal(model,'U','dataset','dset28','outersolnum','all');
% tmp = mphglobal(model,'increase','dataset','dset28','outersolnum','all');
% tmp2 = mphglobal(model,'tox','dataset','dset28','outersolnum','all');
% increase_tox = tmp(1,1:5:end); 
% tox1 = tmp2(1,1:5);
% % Influence of tox - Gox only
% t9 = mphglobal(model,'t','dataset','dset31','outersolnum',1);
% data9 = mphglobal(model,'U','dataset','dset31','outersolnum','all');
% tmp = mphglobal(model,'Gox','dataset','dset31','outersolnum','all');
% tmp2 = mphglobal(model,'tox','dataset','dset31','outersolnum','all');
% Gox_tox = tmp(1,1:5:end); 
% tox2 = tmp2(1,1:5);

save('results_HHcircuit.mat','t1','data1','t2','data2','t3','data3','increase',...
     'frac_ox','t8','data8','increase_tox','tox1','t9','data9','Gox_tox','tox2')

load('results_HHcircuit.mat')
%% Respone to stimulus

figure;
set(gcf,'Units','centimeters','Position',[5 5 8 6])
plot(t1*1e3,data1(:,end:-1:1)*1e3,'LineWidth',2)
set(gca,'FontSize',9,'YColor','k','XColor','k')
xlabel('Time / ms')
ylabel('U / mV')
legend('0.20 A/m2','0.15 A/m2','0.10 A/m2','0.05 A/m2','0.00 A/m2','-0.10 A/m2','-0.20 A/m2')
ylim([-80 30])
colororder(colors2)
saveas(gcf,'Graph_HH_stimilus','pdf')

%% Response to change in capacitance

figure;
set(gcf,'Units','centimeters','Position',[5 5 8 6])
plot(t2*1e3,data2(:,[end:-1:4 2 1])*1e3,'LineWidth',2)
set(gca,'FontSize',9,'YColor','k','XColor','k')
xlabel('Time / ms')
ylabel('U / mV')
legend('1.6','1.4','1.2','1.1','1.0','0.8')
ylim([-80 30])
colororder(colors2(1:end-1))
saveas(gcf,'Graph_HH_fincrease','pdf')

%% Areal fraction equivalent circuit
APs = sum(data3 >= 0,1) >= 1;
APs_matrix = reshape(APs,length(increase),length(frac_ox));

frac_ox_min = zeros(length(increase),1) + nan;
for i = 1:length(increase)
    idx = find(APs_matrix(i,:) > 0,1,'first');
    if numel(idx)
        frac_ox_min(i) = frac_ox(idx);
    end
end

figure;
set(gcf,'Units','centimeters','Position',[5 5 8 6])
plot(increase,frac_ox_min*100,'-o','MarkerSize',6,'Color',colors1{2},'MarkerFaceColor',colors1{1})
set(gca,'FontSize',9,'YColor','k','XColor','k')
xlabel('fincrease = C/C0')
ylabel('Min areal fraction of ox. lesions')
saveas(gcf,'Graph_minAreaPerox','pdf')

%% Influence of tox

figure; hold on; box on
set(gcf,'Units','centimeters','Position',[5 5 16 6])
plot(t8*1e3,data8(:,11:12)*1e3,'-','LineWidth',2)
plot(t8*1e3,data8(:,13)*1e3,':','LineWidth',2)
plot(t8*1e3,data8(:,14:15)*1e3,'-','LineWidth',2)
set(gca,'FontSize',9,'YColor','k','XColor','k')
xlabel('Time / ms')
ylabel('U / mV')
legend('10 ns','1 \mus','10 \mus','10 ms','100 ms')
ylim([-80 30]); xlim([0 200])
colororder(colors2([1:4 6]))
saveas(gcf,'Graph_HH_tox_Cm','pdf')

figure; hold on; box on
set(gcf,'Units','centimeters','Position',[5 5 16 6])
plot(t9*1e3,data9(:,11:12)*1e3,'-','LineWidth',2)
plot(t9*1e3,data9(:,13)*1e3,':','LineWidth',2)
plot(t9*1e3,data9(:,14:15)*1e3,'-','LineWidth',2)
set(gca,'FontSize',9,'YColor','k','XColor','k')
xlabel('Time / ms')
ylabel('U / mV')
legend('10 ns','1 \mus','10 \mus','10 ms','100 ms')
ylim([-80 30]); xlim([0 200])
colororder(colors2([1:4 6]))
saveas(gcf,'Graph_HH_tox_Gox','pdf')

%% CELL MODEL
% Load data
model = mphload('WholeCell2D_CmGox.mph');
% Response to 1 ms stimulus
t4 = mphglobal(model,'t','dataset','dset43','outersolnum',1);
tmp4 = mpheval(model,'Um','edim',0,'selection',4,'dataset','dset43','outersolnum','all');
data4 = squeeze(tmp4.d1);
% Response to 200 ns stimulus
t5 = mphglobal(model,'t','dataset','dset44','outersolnum',1);
tmp5 = mpheval(model,'Um','edim',0,'selection',4,'dataset','dset44','outersolnum','all');
data5 = squeeze(tmp5.d1);
% Response to 20% PoxnoPC
t6 = mphglobal(model,'t','dataset','dset48','outersolnum',1);
tmp6 = mpheval(model,'Um','edim',0,'selection',2,'dataset','dset48','outersolnum','all');
data6 = squeeze(tmp6.d1);

% Response to 20% PoxnoPC 3D multilesion
model = mphload('WholeCell3D_CmGox_MultiLesions.mph');
t7 = mphglobal(model,'t','dataset','dset32','outersolnum',1);
tmp7 = mpheval(model,'Um','edim',0,'selection',3,'dataset','dset32','outersolnum','all');
data7 = squeeze(tmp7.d1);

% Save data
save('results_WholeCell.mat','t4','data4','t5','data5','t6','data6','t7','data7')

load('results_WholeCell.mat')
%% Response to 1 ms stimulus
figure;
set(gcf,'Units','centimeters','Position',[5 5 8 6])
plot(t4*1e3,data4(:,end-1:-1:1)*1e3,'LineWidth',2)
set(gca,'FontSize',9,'YColor','k','XColor','k')
xlabel('Time / ms')
ylabel('U / mV')
legend('13 V/cm','12 V/cm','11 V/cm','10 V/cm','0 V/cm')
ylim([-80 30])
xlim([0 50])
colororder(colors2(1:end-1))
saveas(gcf,'Graph_HHcell_stimulus','pdf')

%% Response to 200 ns stimulus
figure;
set(gcf,'Units','centimeters','Position',[5 5 8 6])
plot(t5*1e3,data5(:,end:-1:1),'LineWidth',2)
set(gca,'FontSize',9,'YColor','k','XColor','k')
xlabel('Time / ms')
ylabel('U / mV')
legend('4 kV/cm','3 kV/cm','2 kV/cm','1 kV/cm','0 kV/cm')
%ylim([-80 30])
xlim([0 50])
colororder(colors2(1:end-1))
saveas(gcf,'Graph_HHcell_nsPEF','pdf')

figure;
plot(t5*1e3,data5(:,end:-1:1),'LineWidth',2)
set(gca,'FontSize',16)
xlabel('Time (ms)')
ylabel('Um (V)')
legend('4 kV/cm','3 kV/cm','2 kV/cm','1 kV/cm','0 kV/cm')
%ylim([-80 30])
xlim([9.999 10.002])

%% Response to 20% PoxnoPC 2D
figure;
set(gcf,'Units','centimeters','Position',[5 5 8 6])
plot(t6*1e3-100,data6(:,end:-1:1)*1e3,'LineWidth',2)
set(gca,'FontSize',9,'YColor','k','XColor','k')
xlabel('Time / ms')
ylabel('U / mV')
legend('3.0%','2.5%','2.0%','1.5%','1.0%')
ylim([-80 30])
xlim([0 100])
colororder(colors2)
saveas(gcf,'Graph_HHcell_Poxno20_2D','pdf')

%% Response to 20% ox lipids
figure;
set(gcf,'Units','centimeters','Position',[5 5 8 6])
plot(t7*1e3-100,data7(:,end:-1:1)*1e3,'LineWidth',2)
set(gca,'FontSize',9,'YColor','k','XColor','k')
xlabel('Time / ms')
ylabel('U / mV')
legend('3.0%','2.5%','2.0%','1.5%','1.0%')
ylim([-80 30])
xlim([0 100])
colororder(colors2)
saveas(gcf,'Graph_HHcell_Poxno20_3D','pdf')

%% Influence of tchange
load('results_tlesion.mat')
tchange = [1e-5 1e-4 1e-3 1e-2 1e-1 1e0 1e1];
colororder(colors2)

figure; hold on; box on
set(gcf,'Units','centimeters','Position',[5 5 8 9])
for i = 1:5
    plot(tchange,farea(i,:)*100,'-o','MarkerSize',6,'Color',colors2{i},'MarkerFaceColor',colors2{i})
end
set(gca,'FontSize',9,'YColor','k','XColor','k','XScale','log','YScale','log','XTick',tchange)
xlabel('tlesion (s)')
ylabel('Min % area of ox. lesions')
xlim([1e-5 1e1]); ylim([1e-3 1e2])
legend('EE13-50%','EE13-100%','Poxno-10%','Poxno-20%','Poxno-30%','Location','SouthWest')
saveas(gcf,'Graph_minAreaPerox_tlesion','pdf')
