% cycle_plot
% plot telemetry and force sensor data on cycle by cycle basis
% global variables:
% rightLegPos()
% assume lead in of some number of samples
figure(1);
clf;
hold on;
minThresh = 0.05;   % left angle is decreasing and cycling to 2 pi
maxThresh = 6.20;   % if threshold is too tight will get extra cycle
maxFound = false;
length = size(rightLegPos,1)
j = 1;
run_begin = 200;  % data from before robot starts running
xtickmin(j)=run_begin; % first sample
xtickmax(j)=run_begin;
% find each segment, keep monotonically increasing, truncate end of segment
% assume no noise beyond threshold in leg position
for i = run_begin:length
    if ((mod(rightLegPos(i), 2*pi) < minThresh) & maxFound)
        maxFound = false;
        j = j+1;
        xtickmin(j) = i;
    end
    if ((mod(rightLegPos(i),2*pi) > maxThresh) & not(maxFound))
        maxFound = true; % only found peak once
        xtickmax(j)=i;
        str = sprintf('New cycle at i=%d, position =%8.3f', i, mod(rightLegPos(i),2*pi));
        display(str);
        plot(mod(rightLegPos(xtickmin(j):xtickmax(j)),2*pi),...
            Frecov1(xtickmin(j):xtickmax(j),2),'r-','LineWidth',1); 
     end
end
%set(ha(4),'YTickLabel','') % only label on left plot
axis([0,1.1*maxt,-1.5,1.5]); legend('F_y')
ylabel('F(N)','FontSize', 14, 'FontName', 'CMU Serif');
xlabel('Leg position (rad)','FontSize', 14, 'FontName', 'CMU Serif');
axis([0,2*pi,-1.5,1.5]); legend('F_y');
%%%%%%%%%%%%%%%%%%%%%

figure(4);
clf;
ha = tight_subplot(3,2,[.02 0.02],[.1 .08],[.1 .03]);
% ha = tight_subplot(columns, rows, [gapy gapx], marg_h, marg_w)

%%%%%%%
% plot each leg cycle
k=1;
axes(ha(3)); plot([0 2*pi],[0 0]);
hold on; 
%for i=1:j-1
for k=1:16
  plot(mod(rightLegPos(xtickmin(k):xtickmax(k)),2*pi),Frecov1(xtickmin(k):xtickmax(k),2),'b-','LineWidth',1); 
  str = sprintf('k = %d, xtickmin= %d   xtickmax=%d\n',k,xtickmin(k),xtickmax(k));
  display(str);
end
ylabel('F(N)','FontSize', 14, 'FontName', 'CMU Serif');
axis([0,2*pi,-1.5,1.5])

axes(ha(4)); hold on; 
for k=17:j-1
  plot(mod(rightLegPos(xtickmin(k):xtickmax(k)),2*pi),Frecov1(xtickmin(k):xtickmax(k),2),'b-','LineWidth',1); 
  str = sprintf('k = %d, xtickmin= %d   xtickmax=%d\n',k,xtickmin(k),xtickmax(k));
  display(str);
end
set(ha(4),'YTickLabel','') % only label on left plot
axis([0,2*pi,-1.5,1.5]); legend('F_y');

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% leg torque   %%%%%%%%%

axes(ha(1)); plot([0 2*pi],[0 0]); hold on; 
for k=1:16
  plot(mod(rightLegPos(xtickmin(k):xtickmax(k)),2*pi),TorqueR(xtickmin(k):xtickmax(k)),...
    'r-','LineWidth',1);
  plot(mod(rightLegPos(xtickmin(k):xtickmax(k)),2*pi),-TorqueL(xtickmin(k):xtickmax(k)),...
    'b-','LineWidth',1);
end
ylabel('\tau (mN-m)','FontSize', 14, 'FontName', 'CMU Serif');
axis([0,2*pi,-2.5,2.5]); 
title('Before contact','FontSize', 12, 'FontName', 'CMU Serif');

axes(ha(2)); plot([0 2*pi],[0 0]); hold on; 
for k=17:j-1
  plot(mod(rightLegPos(xtickmin(k):xtickmax(k)),2*pi),TorqueR(xtickmin(k):xtickmax(k)),...
    'r-','LineWidth',1);
  plot(mod(rightLegPos(xtickmin(k):xtickmax(k)),2*pi),-TorqueL(xtickmin(k):xtickmax(k)),...
    'b-','LineWidth',1);
end
set(ha(2),'YTickLabel','') % only label on left plot
axis([0,2*pi,-2.5,2.5]); legend('Right torque','Left torque')
title('after contact','FontSize', 12, 'FontName', 'CMU Serif');
%
%%%%%%%% body forces before and after contact with walls %%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Moments  Mx = Frecov1(4)

axes(ha(5)); plot([0 2*pi],[0 0]);
hold on; 
%for i=1:j-1
for k=1:16
  plot(mod(rightLegPos(xtickmin(k):xtickmax(k)),2*pi),Frecov1(xtickmin(k):xtickmax(k),4),'r-','LineWidth',1); 
  str = sprintf('k = %d, xtickmin= %d   xtickmax=%d\n',k,xtickmin(k),xtickmax(k));
  display(str);
end
ylabel('M (mN-M)','FontSize', 14, 'FontName', 'CMU Serif');
axis([0,2*pi,-50,50]); 

axes(ha(6)); hold on; 
for k=17:j-1
  plot(mod(rightLegPos(xtickmin(k):xtickmax(k)),2*pi),Frecov1(xtickmin(k):xtickmax(k),4),'r-','LineWidth',1); 
  str = sprintf('k = %d, xtickmin= %d   xtickmax=%d\n',k,xtickmin(k),xtickmax(k));
  display(str);
end
axis([0,2*pi,-50,50])
set(ha(6),'YTickLabel','') % only label on left plot
legend('M_x')



%%%%%%%%%%
%%%% change fonts, line widths for all plots, etc:
set(ha(1:4),'XTickLabel','') % only 1 time label
for i = 1:6
    axes(ha(i));
    set(gca,'FontName','CMU Serif','FontSize',14);
    %axis([0,10,-1.5,1.5]);
    hold on
    temp = get(gca,'XTick');
    plot([temp(1),temp(end)],[0,0],'k','LineWidth',1);
    grid on
    
end
axes(ha(5));
xlabel('Rt Leg position (rad)','FontSize', 18, 'FontName', 'CMU Serif');
axes(ha(6));
xlabel('Rt Leg position (rad)','FontSize', 18, 'FontName', 'CMU Serif');

