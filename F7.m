clc
clear all


load ./data/bouma

right =  [bouma.Ecc2_5__0_0;bouma.Ecc5_0__0_0;bouma.Ecc10_0__0_0]
left =  [bouma.Eccm2_5__0_0;bouma.Eccm5_0__0_0;bouma.Eccm10_0__0_0]

figure(7)
% individual_diff = histogram(log10(nanmean([left;right])),[-2:0.05:0])
% subplot(1,2,2)
histogram(log10(nanmean([nanmean(left);nanmean(right)])),[-2:0.1:0],'FaceColor','None')
xlim([-1.8 0])
hold on

title('Log Bouma factor across observers at horizontal midline')
set(gca,'Fontsize',15)
ylabel('Count')
xlabel('Log Bouma factor (B)')
box off

mymean=log10(nanmean(nanmean([nanmean(left);nanmean(right)])));
p = plot([mymean mymean],[ylim],'-.','LineWidth',2,'Color',[1 0 0]);
legend(p,sprintf('geo mean = %.2f',10^mymean))
% text(-0.6,20,sprintf('geo mean = %.2f',10^mymean))


figg = gca;
figg.XLabel.String =  ['Log Bouma factor' '{\it B}']
% cat(2,' {\it R}',figg.Title.String(2:findN-2) ,'{\it, N}', figg.Title.String(findN+1:end))

box off
legend box off