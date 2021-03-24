figure(3)
load('./data/staircase.mat')


plot(staircase,'k','Linewidth',3); hold on


staircase = staircase;


for c = 1 : length(staircase)-1
    
    tmp = staircase(c) - staircase(c+1)
    
    if tmp>0
        
        h=plot(c,staircase(c),'.r','MarkerSize',40,'Color',round([79 126 96]/255,2))
        
        tmp_vec(c) = 0;
    else
        h2 = plot(c,staircase(c),'.r','MarkerSize',40)
        
        tmp_vec(c) = 1;
    end
end

legend([h h2],{'Correct';'Incorrect'})



ylabel('Flanker spacing (deg)')
xlabel({'Tested letter';'Trial number'})
xlabel({'Trial number'})

set(gca,'Fontsize',20)
title(sprintf('Example of Quest staircase at 2.5 %s',char(176)))



set(gcf,'Position',[ 560   409   867   539])