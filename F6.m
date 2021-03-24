clc 
clear

cmap(1,:) = [0.0314    0.2431    0.5176];
cmap(2,:) = [0.5569    0.0039    0.3216]

figure(6); clf
load ./data/data

crowding = data;
load ./data/acuity_for_sloan.mat
acuity = data;

subplot(1,3,1)
crowding_5_deg = nanmean([crowding.Ecc5_0__0_0;crowding.Eccm5_0__0_0]);
acuity_5_deg = nanmean([acuity.Ecc5_0__0_0;acuity.Eccm5_0__0_0]);

% subplot(3,1,1)
myplot = plot((crowding_5_deg),(acuity_5_deg),'.','MarkerSize',20,'Color',cmap(1,:));
set(gca,'xscale','log','yscale','log')

ylabel('Acuity (deg)')


nn = find(isnan(acuity_5_deg));

acuity_5_deg(nn) = [];
crowding_5_deg(nn) = [];


nn = find(isnan(crowding_5_deg));
crowding_5_deg(nn) = [];
acuity_5_deg(nn) = [];


[R,pval] = corr(acuity_5_deg',crowding_5_deg','type','Spearman')
title(sprintf('Sloan vs Sloan \n R = %.2f N=%i, Ecc. 5 deg ',R,length(crowding_5_deg)))
axis manual
ylim([0.1 5])
xlim([0.1 5])

xticks([0.1 0.25 0.5 2 5])
yticks([0.1 0.25 0.5 2 5])
% set(gca,'DataAspectRatio',[0.5 1 1])
% axis tight
% axis equal
axis square
box off
set(gca,'Fontsize',15)
% ylim([0.1 2])
xlabel('Crowding (deg)')

%%
subplot(1,3,2)
load ./data/data_p

crowding = data;
load ./data/acuity_for_pelli.mat
acuity = data;


crowding_5_deg = nanmean([crowding.Ecc5_0__0_0;crowding.Eccm5_0__0_0]);
acuity_5_deg = nanmean([acuity.Ecc5_0__0_0;acuity.Eccm5_0__0_0]);

% subplot(3,1,2)
myplot = plot(crowding_5_deg,acuity_5_deg,'.','MarkerSize',20,'Color',cmap(1,:))
set(gca,'xscale','log','yscale','log')

ylabel('Acuity (deg)')

nn = find(isnan(acuity_5_deg));

acuity_5_deg(nn) = [];
crowding_5_deg(nn) = [];


nn = find(isnan(crowding_5_deg));
crowding_5_deg(nn) = [];
acuity_5_deg(nn) = [];


[R,pval] = corr(acuity_5_deg',crowding_5_deg','type','Spearman')
title(sprintf('Pelli vs Sloan \n R = %.2f N=%i Ecc. 5 deg',R,length(crowding_5_deg)))

axis manual
ylim([0.1 5])
xlim([0.1 5])

xticks([0.1 0.25 0.5 2 5])
yticks([0.1 0.25 0.5 2 5])
% set(gca,'DataAspectRatio',[0.5 1 1])
% axis tight
% axis equal
axis square
box off
% ylim([0.1 2])
set(gca,'Fontsize',15)
xlabel('Crowding (deg)')

%%
subplot(1,3,3)

load ./data/data_p

crowding = data;
load ./data/acuity_for_pelli.mat
acuity = data;


crowding_5_deg = [crowding.Ecc0_0__0_0];
acuity_5_deg = [acuity.Ecc0_0__0_0];

% subplot(3,1,3)
myplot = plot(crowding_5_deg,acuity_5_deg,'.','MarkerSize',20,'Color',cmap(2,:))
set(gca,'xscale','log','yscale','log')



ylabel('Acuity (deg)')
xlabel('Crowding (deg)')

nn = find(isnan(acuity_5_deg));
acuity_5_deg(nn) = [];
crowding_5_deg(nn) = [];
nn = find(isnan(crowding_5_deg));
crowding_5_deg(nn) = [];
acuity_5_deg(nn) = [];


[R,pval] = corr(acuity_5_deg',crowding_5_deg','type','Spearman')
title(sprintf('Pelli vs Sloan \n R = %.2f N=%i, Ecc. 0 deg ',R,length(crowding_5_deg)))

ylim([0.03 5])
xlim([0.03 5])

xticks([0.01 0.1 0.25 0.5 2 5])
yticks([0.01 0.1 0.25 0.5 2 5])

axis square
box off
% ylim([0.1 2])
set(gca,'Fontsize',15)