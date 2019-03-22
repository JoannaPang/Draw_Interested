function eval_res = plotDrawSave_pang_0316(numTrk,plotDrawStyle,aveSuccessRatePlot,idxSeqSet,rankNum,rankingType,rankIdx,nameTrkAll,thresholdSet,titleName,xLabelName,yLabelName,figName,configPlot)

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


fontSize = configPlot.fontSize;% %title's fontSize %pang-fix
fontSizeLegend = configPlot.fontSizeLegend;% %legend's fontSize %pang-fix
lineWidth = configPlot.lineWidth; %lineWidth of color lines %pang-fix
fontSizeAxes = configPlot.fontSizeAxes;
location = configPlot.location;

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
axes1.FontSize = 20; %the fontSize of kedu %pang-fix
axes1.FontWeight = 'bold';
legend(tmpName,'Interpreter', 'none','fontsize',fontSizeLegend,'FontWeight','bold','FontName','Times New Roman','Location',location);

% legend(tmpName,'Interpreter', 'none','fontsize',fontSizeLegend,'FontName','Times New Roman','FontWeight','bold', 'Location','southeast');
% legend(tmpName,'Interpreter', 'none','fontsize',fontSizeLegend,'FontName','Times New Roman','FontWeight','bold', 'Location','southeast');
% title(titleName,'fontsize',fontSize,'FontName','Times New Roman','FontWeight','bold');
% xlabel(xLabelName,'fontsize',fontSize,'FontName','Times New Roman','FontWeight','bold');
% ylabel(yLabelName,'fontsize',fontSize,'FontName','Times New Roman','FontWeight','bold');

%legend(tmpName,'Interpreter', 'none','fontsize',12,'FontName','Times New Roman','FontWeight','bold', 'Location','southeast');
%,'position',[0.3,1]
title(titleName,'fontsize',fontSize,'FontName','Times New Roman','FontWeight','bold');
xlabel(xLabelName,'fontsize',fontSize,'FontName','Times New Roman','FontWeight','bold');
ylabel(yLabelName,'fontsize',fontSize,'FontName','Times New Roman','FontWeight','bold');
hold off

set(gca,'LineWidth',5);%lineWidth of keduxian %pang-fix
set(gcf,'PaperSize',[5 5]);%(width,hight)
%set(gcf,'PaperPosition',[0 0 20 20]);
%set(gcf,'PaperType','a3');pang-add

saveas(gcf,figName,'pdf');
%saveas(gcf,figName,'png');
clf;

end
