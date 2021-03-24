
figure(2)

cccmap(1,:) = round([130 120 120]/255,2);
cccmap(2,:) = round([189 93 181]/255,2);
cccmap(3,:) = round([142 115 132]/255,2);

addpath(genpath('utils'));
load ./data/bouma



leg = {'upper ';'right';'lower';'left'};
numleg{1} = 1:4:12;
numleg{2} = 3:4:12;
numleg{3} = 2:4:12;
numleg{4} = 4:4:12;


for s = 1 : length(numleg)
    ct = 1;
    
    for f = numleg{s}
        
        newbouma(:,s,ct) = bouma.(field{f});
        
        ct = ct + 1;
        
    end
end

%%
figure(2)

leg = {'upper';'right';'lower';'left'};


for s = 1: size(newbouma,3);
    
    
    tmp = squeeze((newbouma(:,:,s)));
    
    
    [E,Y1] = bootci(1000, {@nanmean, tmp}, 'type', 'per', 'alpha',0.34);
    E = abs(E - nanmean(Y1));
    bigmean(s,:) = nanmean(Y1);
    bigstd(s,:) = nanmean(E);
    
    
    
    er(s) = errorbar([1 2 3 4],nanmean(Y1),nanmean(E),'o-','color',ccmap(s,:),'Linewidth',3); hold on
    
    
    
end



ylabel('Bouma factor');
xlabel('Meridian');
xticks(1:4);
xticklabels(leg);




%%
bouma_l = [bouma.Eccm10_0__0_0 bouma.Eccm5_0__0_0 bouma.Eccm2_5__0_0];
bouma_r = [bouma.Ecc10_0__0_0 bouma.Ecc5_0__0_0 bouma.Ecc2_5__0_0];


hold on

[pval_lr, observeddifference, effectsize] = permutationTest(bouma_l, bouma_r, 1000,'sidedness','both');

plot([2 2],[0.315 0.325],'-','LineWidth',1,'Color',[0.5 0.5 0.5]);
plot([4 4],[0.315 0.325],'-','LineWidth',1,'Color',[0.5 0.5 0.5]);


plot([2 2.05],[0.325 0.325],'-','LineWidth',1,'Color',[0.5 0.5 0.5]);
plot([2 2.05],[0.315 0.315],'-','LineWidth',1,'Color',[0.5 0.5 0.5]);


plot([3.95 4.00],[0.325 0.325],'-','LineWidth',1,'Color',[0.5 0.5 0.5]);
plot([3.95 4.00],[0.315 0.315],'-','LineWidth',1,'Color',[0.5 0.5 0.5]);



P = zeros(2,2);
P(:)  = pval_lr;

t = text(3,0.32,sprintf('p=%.2f',(P(1,1))),'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'middle','FontSize',15,'Color',[0 0 0]);

ylim([0.1 0.35]);

%%

bouma_u = [bouma.Ecc0_0__10_0 bouma.Ecc0_0__5_0 bouma.Ecc0_0__2_5];
bouma_d = [bouma.Ecc0_0__m10_0 bouma.Ecc0_0__m5_0 bouma.Ecc0_0__m2_5];

figure(2)

plot([1 1],[0.295 0.305],'-','LineWidth',1,'Color',[0.5 0.5 0.5]);
plot([3 3],[0.295 0.305],'-','LineWidth',1,'Color',[0.5 0.5 0.5]);

plot([1 1.05],[0.295 0.295],'-','LineWidth',1,'Color',[0.5 0.5 0.5]);
plot([1 1.05],[0.305 0.305],'-','LineWidth',1,'Color',[0.5 0.5 0.5]);


plot([2.95 3],[0.295 0.295],'-','LineWidth',1,'Color',[0.5 0.5 0.5]);
plot([2.95 3],[0.305 0.305],'-','LineWidth',1,'Color',[0.5 0.5 0.5]);


[pval_ud, observeddifference, effectsize] = permutationTest(bouma_u, bouma_d, 1000,'sidedness','both');

P = zeros(2,2);
P(:)  = pval_ud;


t = text(2,0.30,sprintf('p=%.2f',(P(1,1))),'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'middle','FontSize',15,'Color',[0 0 0]);

xlim([0.9 4.1])


leg2 = legend;
leg2.String= {sprintf('2.5%s',char(176));sprintf('5%s',char(176));sprintf('10%s',char(176))};
leg2.Location = 'southWest';
title('Bouma factor vs. meridian');
set(gca,'Fontsize',15)

title(leg2,'Radial eccentricity','fontsize',15);
%%
set(gcf,'Position',[    866   338   753   551])
legend boxoff

box off
ylim auto

mygeomean = geomean(bigmean);

t = table((round(mygeomean(1),2)),(round(mygeomean(2),2)),(round(mygeomean(3),2)),(round(mygeomean(4),2)));
t.Properties.VariableNames = leg;


disp(t)


fprintf('Ratio R/L = %.2f \n',t.right/t.left)
fprintf('Ratio D/U = %.2f \n',t.lower/t.upper)
fprintf('Bouma factor averaged across meridians = %.2f \n',geomean([t.right t.upper t.left t.lower]))


