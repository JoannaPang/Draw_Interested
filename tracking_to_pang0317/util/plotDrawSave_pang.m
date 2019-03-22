function eval_res = plotDrawSave_pang(numTrk,plotDrawStyle,aveSuccessRatePlot,idxSeqSet,rankNum,rankingType,rankIdx,nameTrkAll,thresholdSet,titleName,xLabelName,yLabelName,figName,configPlot)

for idxTrk = 1:numTrk
    %each row is the sr plot of one sequence
    tmp = aveSuccessRatePlot(idxTrk, idxSeqSet,:);
    aa = reshape(tmp,[length(idxSeqSet),size(aveSuccessRatePlot,3)]);
    aa = aa(sum(aa,2)>eps,:);
    bb = mean(aa, 1);
    switch rankingType
        case 'AUC'
            perf(idxTrk) = mean(bb);
        case 'threshold'
            perf(idxTrk) = bb(rankIdx);
    end
end

[~,indexSort] = sort(perf,'descend');


fontSize = configPlot.fontSize;%16
fontSizeLegend = configPlot.fontSizeLegend;%10
%fontSizeLegend = 22;
lineWidth = configPlot.lineWidth;%2
fontSizeAxes = configPlot.fontSizeAxes;%14
location = configPlot.location;

%delete white edge
left_right = configPlot.left_right;
up_down = configPlot.up_down;
bbwidth = configPlot.bbwidth;
bbheight = configPlot.bbheight;

i=1;
figure1 = figure;

axes1 = axes('Parent',figure1,'FontSize',fontSizeAxes,'FontName','Times New Roman');

for idxTrk = indexSort(1:rankNum)
    tmp = aveSuccessRatePlot(idxTrk,idxSeqSet,:);
    aa = reshape(tmp,[length(idxSeqSet),size(aveSuccessRatePlot,3)]);
    aa = aa(sum(aa,2)>eps,:);
    bb = mean(aa, 1);
    switch rankingType
        case 'AUC'
            score = mean(bb);
            tmp=sprintf('%.1f', score*100);
            disp([nameTrkAll{idxTrk} ' : ' tmp]);
        case 'threshold'
            score = bb(rankIdx);
            tmp=sprintf('%.1f', score*100);
            disp([nameTrkAll{idxTrk} ' : ' tmp]);
    end    
    
    tmpName{i} = [nameTrkAll{idxTrk} ' [' tmp ']'];
    eval_res{i} = {nameTrkAll{idxTrk},tmp};

    % h(i) = plot(thresholdSet,bb,'color',plotDrawStyle{i}.color, 'lineStyle', plotDrawStyle{i}.lineStyle,'lineWidth', 1,'Parent',axes1);
    h(i) = plot(thresholdSet,bb,'color',plotDrawStyle{idxTrk}.color, 'lineStyle', plotDrawStyle{idxTrk}.lineStyle,'lineWidth', lineWidth,'Parent',axes1);
    hold on
    i=i+1;
end

axes1.FontName = 'Times New Roman';
%axes1.FontSize = 15; %the fontSize of kedu %pang-fix
axes1.FontWeight = 'bold';
legend(tmpName,'Interpreter', 'none','fontsize',fontSizeLegend,'FontWeight','bold','FontName','Times New Roman','Location',location);

% legend(tmpName,'Interpreter', 'none','fontsize',fontSizeLegend,'FontName','Times New Roman','FontWeight','bold', 'Location','southeast');
% legend(tmpName,'Interpreter', 'none','fontsize',fontSizeLegend,'FontName','Times New Roman','FontWeight','bold', 'Location','southeast');
% title(titleName,'fontsize',fontSize,'FontName','Times New Roman','FontWeight','bold');
% xlabel(xLabelName,'fontsize',fontSize,'FontName','Times New Roman','FontWeight','bold');
% ylabel(yLabelName,'fontsize',fontSize,'FontName','Times New Roman','FontWeight','bold');

%legend(tmpName,'Interpreter', 'none','fontsize',12,'FontName','Times New Roman','FontWeight','bold', 'Location','southeast');

title(titleName,'fontsize',fontSize,'FontName','Times New Roman','FontWeight','bold');
xlabel(xLabelName,'fontsize',fontSize,'FontName','Times New Roman','FontWeight','bold');
ylabel(yLabelName,'fontsize',fontSize,'FontName','Times New Roman','FontWeight','bold');

% title(titleName,'horizontalalignment','center');
% xlabel(xLabelName);
% ylabel(yLabelName);



hold off

set(gca,'LineWidth',4);

%hu's method
saveas(gcf,figName,'svg');
set(figure1,'Units','Inches');
pos = get(figure1,'Position');
%set(figure1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
%pos(1)-x-axis,pos(2)-y-axis,pos(3)-windows' length,pos(4)-windows' weight

%set(figure1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3)+bbweight, pos(4)+bbhight]) 
%Success! but have not delete white edge

%set(figure1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)],'PaperPosition',[-0.2 0 6.6 4.4]) 
%,'PaperPosition',[0 0 6 5]%means -- [left-right up-down weitht hight]
%,'PaperPosition',[0 0 pos(1) pos(2)]

set(figure1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)],'PaperPosition',[left_right up_down bbwidth bbheight]) 
print(figure1,figName,'-dpdf','-r0')


%pang's method
% set(gcf,'PaperSize',[6 5]);
% set(gcf,'PaperPosition',[0 0 6 5]);
%saveas(gcf,figName,'pdf');
%saveas(gcf,figName,'png');
%clf;


pause(0.2);
close(figure1);

end
