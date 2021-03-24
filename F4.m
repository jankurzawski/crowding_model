%%

load ./data/bouma
clear newdata

ccmap(1,:) = round([143 208 142]/255,2);   %// color first row - red
ccmap(2,:) = round([159 202 223]/255,2);   %// color 25th row - green
ccmap(3,:) = round([253 192 140]/255,2);
leg = {'upper ';'right';'lower';'left'}

numleg{1} = 1:4:12;
numleg{2} = 3:4:12;
numleg{3} = 2:4:12;
numleg{4} = 4:4:12;



for s = 1 : length(numleg)
    ct = 1
    
    for f = numleg{s}
        
        newdata_b(:,s,ct) = bouma.(field{f})
        
        ct = ct + 1
        
    end
end



leg = {'upper \pi/2';'right 2\pi ';'lower 3\pi/2 ';'left \pi'};

Eccen_leg = {'2.5','5','10'};
Eccen = {'2.5','5','10'};

for s = 1: size(newdata_b,3);
    
    
    tmp = squeeze(newdata_b(:,:,s));
 
    
    [E,Y1] = bootci(10000, {@nanmean, tmp}, 'type', 'per', 'alpha',0.34);
    E = abs(E - nanmean(Y1));
    bigmean(s,:) = nanmean(Y1);
    bigstd(s,:) = nanmean(E);

    cccmap(1,:) = round([130 120 120]/255,2);
    cccmap(2,:) = round([189 93 181]/255,2);
    cccmap(3,:) = round([142 115 132]/255,2);
    
end


%%




figure(4)
theta=deg2rad([0,90,180,270])

for s = 1 : size(bigmean,1)
    tmp_crow = bigmean(s,:);
    tmp_std = bigstd(s,:);
    crowdingX = [0 tmp_crow(2) 0 -tmp_crow(4) 0];
    crowdingY = [tmp_crow(1) 0 -tmp_crow(3) 0 tmp_crow(1)];
    
    %
    crowdingX_cp = [0 tmp_crow(2)-tmp_std(1) 0 -tmp_crow(4)+tmp_std(1)];
    crowdingY_cp = [tmp_crow(1)-tmp_std(2) 0 -tmp_crow(3)+tmp_std(2) 0];
    crowdingX_cp2 = [0 tmp_crow(2)+tmp_std(3) 0 -tmp_crow(4)-tmp_std(3)];
    crowdingY_cp2 = [tmp_crow(1)+tmp_std(4) 0 -tmp_crow(3)-tmp_std(4) 0];
        

    cp = polyshape({crowdingX_cp,crowdingX_cp2},{crowdingY_cp,crowdingY_cp2})

    
    
    plot(cp,'FaceColor',ccmap(s,:),'EdgeAlpha',0);hold on
    hh(s)=plot(crowdingX,crowdingY,'Color',ccmap(s,:),'LineWidth',2);hold on
end
%
ylim([-0.4 0.4])
xlim([-0.4 0.4])
axis square

line(xlim(), [0,0], 'LineWidth', 2, 'Color',[0.5 0.5 0.5],'LineStyle','--');
line([0 0], ylim(), 'LineWidth', 2, 'Color',[0.5 0.5 0.5],'LineStyle','--');



xlabel('Horizontal Bouma factor ')
ylabel('Vertical Bouma factor ')
set(gca,'Fontsize',25)
title('Polar plot of Bouma factor')
grid on
set(gcf,'Position',[ 881   385   560   420])
% set(gca,'yscale','log')
% set(gca,'xscale','log')

axis square tight
axis off



r=0.2
th = 0:pi/50:2*pi;
xunit = r * cos(th)+0;
yunit = r * sin(th)+0;

h = plot(xunit, yunit,'--k','Linewidth',2); hold on
h.Color(4) = 0.15;

text(r,0,sprintf('%.1f',r),'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'bottom','Color','black','FontSize',15)


r=0.1
th = 0:pi/50:2*pi;
xunit = r * cos(th)+0;
yunit = r * sin(th)+0;


h = plot(xunit, yunit,'--k','Linewidth',2); hold on
h.Color(4) = 0.15;

text(r,0,sprintf('%.1f',r),'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'bottom','Color','black','FontSize',15)


r=0.3
th = 0:pi/50:2*pi;
xunit = r * cos(th)+0;
yunit = r * sin(th)+0;

h = plot(xunit, yunit,'--k','Linewidth',2); hold on
h.Color(4) = 0.15;
text(r,0,sprintf('%.1f',r),'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'bottom','Color','black','FontSize',15)

title('Bouma factor vs. meridian (polar plot)')

set(gcf,'Position',[    866   338   753   551])


%%
