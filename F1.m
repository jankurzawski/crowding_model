
ccmap(1,:) = round([143 208 142]/255,2);  
ccmap(2,:) = round([159 202 223]/255,2);  
ccmap(3,:) = round([253 192 140]/255,2);

load ./data/data_p

data_p = data;

load ./data/data



figure(1)

field = fieldnames(data);

for fields = 1 : length(field)
    tmp = field{fields}(4:end);
    
    u = strfind(tmp,'__');
    x = tmp(1:u-1);
    y = tmp(u+2:end);
    
    
    
    if strfind(y,'m')
        
        ind = strfind(y,'m');
        y(ind)  = '-';
        
    end
    
    
    if strfind(y,'_')
        
        ind = strfind(y,'_');
        y(ind)  = '.';
        
    end
    
    
    if strfind(x,'m')
        
        ind = strfind(x,'m');
        x(ind)  = '-';
        
    end
    
    
    if strfind(x,'_')
        
        ind = strfind(x,'_');
        x(ind)  = '.';
        
    end
    
    x = str2double(x);
    y = str2double(y);
    
    r = sqrt(x^2+y^2);
    
    
    r = abs(r);
    r(r==0) = [];
    if isempty(r)
        
        r = 1
        
    end
    Eccs(fields) = r;
    th = 0:pi/50:2*pi;
    xunit = r * cos(th)+0;
    yunit = r * sin(th)+0;
    
    if fields == 1 || fields == 5 || fields == 9
        
        h = plot(xunit, yunit,'--k','Linewidth',2); hold on
        h.Color(4) = 0.15;
    end
    if fields <= 4
        t = text(x,y,sprintf('%i',sum(isfinite(data.(field{fields})))),'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle','FontSize',15,'Color',ccmap(1,:),'FontWeight','bold')
        
    elseif fields>4 & fields<=8
        t = text(x,y,sprintf('%i',sum(isfinite(data.(field{fields})))),'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle','FontSize',15,'Color',ccmap(2,:),'FontWeight','bold')
    elseif fields>8 & fields<=12
        t = text(x,y,sprintf('%i',sum(isfinite(data.(field{fields})))),'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle','FontSize',15,'Color',ccmap(3,:),'FontWeight','bold')
    end
  
    
    
    ylabel('Vertical eccentricity (deg)')
    xlabel('Horizontal eccentricity (deg)')
    
    title(sprintf('Number of participants'))
    
    
end
title(sprintf('Number of participants'))

t = text(0,0,sprintf('%i',sum(isfinite(data_p.Ecc0_0__0_0))),'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'middle','FontSize',15,'Color',round([197 33 112]/255,2),'FontWeight','bold')



set(gca,'Fontsize',15)
set(gcf,'Position',[    1000         558         560         420])
axis image
ylim([-12.5 12.5])
xlim([-12.5 12.5])