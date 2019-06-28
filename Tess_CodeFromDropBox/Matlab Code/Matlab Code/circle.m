function h = circle(x,y,r,c)

th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = fill(xunit, yunit,c,'EdgeColor','w');

xlim([-3.2 3.2])
ylim([-3.2 3.2])
pbaspect([1 1 1])
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
set(gca,'xtick',[])
set(gca,'ytick',[])

end