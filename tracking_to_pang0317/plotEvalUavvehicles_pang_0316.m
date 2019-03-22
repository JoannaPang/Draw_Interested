close all;
clear, clc;
warning off all;
addpath(genpath('.'));

%% path config
datasetPath = '/data/data/uav-vehicles/'; % the dataset path
seqs = configSeqs(fullfile(datasetPath,'sequences'), 'test2.txt'); % the set of sequences
annoPath = fullfile(datasetPath, 'annotations');

evalType = 'OPE'; % the evaluation type such as 'OPE','SRE','TRE'
trackResPath = ['./results/results_' evalType '/'];
trackers = {
           % struct('name','uavvecgt','namePaper','GT')
%             struct('name','meta_crest_drone','namePaper','meta_crest')
%             struct('name','meta_sdnet_drone','namePaper','meta_sdnet')
%             %struct('name','acgan2','namePaper','acgan2')
%             % struct('name','drone2','namePaper','drone2')
%             %struct('name','kittiac1','namePaper','KITTI-RCAC2')
%             struct('name','adnet_drone','namePaper','ADNET')
%             %struct('name','drone10','namePaper','RCAC10')
%             %struct('name','drone','namePaper','RCAC1')
%             %struct('name','offline','namePaper','KITTI-offline')
%             %struct('name','fast2','namePaper','RCAC5')
%             %struct('name','drone8','namePaper','RCAC8')
%             struct('name','vital_drone','namePaper','VITAL')
%             struct('name','mdnet_drone','namePaper','MDNET')
%             struct('name','STRCF_drone','namePaper','STRCF')
%             struct('name','MCCT_drone','namePaper','MCCT') 
%             struct('name','siamFC_drone','namePaper','simFC')
%             struct('name','drone10','namePaper','RCAC')
            % struct('name','SiamRPN_AlexNet_Drone2018','namePaper','SiamRPN')
            struct('name','CRAC_uav-vehicles','namePaper','CRAC_mdnet') %MCCT_uav-vehicles
            struct('name','siamrpn_1_uav-vehicles','namePaper','CRAC_siam')
            struct('name','siamfcori_uav-vehicles','namePaper','siamFC')
            struct('name','Meta_CREST_uav-vehicles','namePaper','meta_crest')
            %struct('name','siamrpndrone_7_uav-vehicles','namePaper','siamrpndrone')
            %struct('name','siamrpnkitti_7_uav-vehicles','namePaper','siamrpnkitti') %siamrpnori_uav-vehicles
            struct('name','siamrpnori_uav-vehicles','namePaper','siamRPN') %siamrpnori_uav-vehicles
            %struct('name','siamrpn_7_uav-vehicles','namePaper','siamrpn_7') %siamrpnori_uav-vehicles
            struct('name','MDNet_uav-vehicles','namePaper','MDNet') %siamrpnori_uav-vehicles
            %struct('name','ADNet_uav-vehicles','namePaper','ADNet') %siamrpnori_uav-vehicles
            struct('name','Vital_uav-vehicles','namePaper','VITAL') %siamrpnori_uav-vehicles
%            struct('name','SiamRPN_AlexNet_uav-vehicles','namePaper','DaSiamrpn')
            
            struct('name','MCCT_uav-vehicles','namePaper','MCCT')
            struct('name','STRCF_uav-vehicles','namePaper','STRCF')
            struct('name','ACT_uav-vehicles','namePaper','ACT')
            struct('name','ADNet_uav-vehicles','namePaper','ADNet') %Meta_SDNet_uav-vehicles Meta_CREST_uav-vehicles
            struct('name','Meta_SDNet_uav-vehicles','namePaper','meta_sdnet')
            
            %struct('name','CRAC2_uav-vehicles','namePaper','CRAC_100')
            %struct('name','CRAC3_uav-vehicles','namePaper','CRAC_KITTI')
            }; % the set of trackers

attrPath = fullfile(datasetPath, 'annotations', 'att');  % the folder that contains the annotation files for sequence attributes

attName = {'background clutter','camera motion','object motion','small object','illumination variations',...
    'object blur','scale variations','long-term tracking','large occlusion'};
attFigName = {'background_clutter','camera_motion','object_motion','small_object','illumination_variations',...
    'object_blur','scale_variations','long_term_tracking','large_occlusion'};

%% plot config     
configPlot.fontSize = 15; %title's fontSize %pang-fix
configPlot.fontSizeLegend = 12; %legend's fontSize %pang-fix
configPlot.lineWidth =4; %lineWidth of color lines %pang-fix
configPlot.fontSizeAxes = 15;

%pang-add
%delete white edge
configPlot.left_right = -0.2;
configPlot.up_down = 0;
configPlot.bbwidth = 6.6;
configPlot.bbheight = 4.4;

%%

reEvalFlag = 1; % the flag to re-evaluate trackers
numSeq = length(seqs);
numTrk = length(trackers);

nameTrkAll = cell(numTrk,1);
for idxTrk = 1:numTrk
    t = trackers{idxTrk};
    nameTrkAll{idxTrk} = t.namePaper;
end

nameSeqAll = cell(numSeq,1);
numAllSeq = zeros(numSeq,1);

att = [];
for idxSeq = 1:numSeq
    s = seqs{idxSeq};
    nameSeqAll{idxSeq} = s.name;    
    s.len = s.endFrame - s.startFrame + 1;
    numAllSeq(idxSeq) = s.len;
    att(idxSeq,:) = load([attrPath '/' s.name '_att.txt']);
end

attNum = size(att,2);

evalResPath = './evalRes';
figPath = './evalRes/figs/overall/';
perfMatPath = './evalRes/perfMat/overall/';
attrSeqListPath = './evalRes/attrSeqList';
attrResPath = './evalRes/attrRes';

for path_item = {figPath,perfMatPath,attrSeqListPath,attrResPath,evalResPath}
    if ~exist(path_item{1},'dir')
        mkdir(path_item{1});
    end
end

metricTypeSet = {'overlap','error'};
result = struct();

rankNum = -1;%number of plots to show------------------------------------------------------------------------
%plotDrawStyle = getDrawStyle(rankNum);
plotSetting_pang; %pang-fix

thresholdSetOverlap = 0:0.05:1;
thresholdSetError = 0:50;

%%% 
for i = 1:length(metricTypeSet)
    metricType = metricTypeSet{i};%error,overlap
    
    switch metricType
        case 'overlap'
            thresholdSet = thresholdSetOverlap;
            rankIdx = 11;
            xLabelName = 'Overlap threshold';
            yLabelName = 'Success rate';
        case 'error'
            thresholdSet = thresholdSetError;
            rankIdx = 21;
            xLabelName = 'Location error threshold';
            yLabelName = 'Precision';
    end  
        
    % if(strcmp(metricType,'error') && strcmp(rankingType,'AUC') || strcmp(metricType,'overlap') && strcmp(rankingType,'threshold'))
    %    continue;
    % end
    if (strcmp(metricType, 'error'))
        rankingType='threshold';
    else
        rankingType='AUC';
    end
    
    tNum = length(thresholdSet);                    
    plotType = [metricType '_' evalType];

    switch metricType
        case 'overlap'
            titleName = ['Success plots of ' evalType];
            configPlot.location = 'southwest';
        case 'error'
            configPlot.location = 'southeast';
            titleName = ['Precision plots of ' evalType];
    end
    disp(titleName);
    
    dataName = [perfMatPath 'aveSuccessRatePlot_' num2str(numTrk) 'alg_'  plotType '.mat'];

    % If the performance Mat file, dataName, does not exist, it will call genPerfMat to generate the file.
    if(~exist(dataName, 'file') || reEvalFlag)
        genPerfMat(annoPath, seqs, trackers, evalType, trackResPath, nameTrkAll, perfMatPath);
    end        

    load(dataName);
    numTrk = size(aveSuccessRatePlot,1);        
    if(rankNum > numTrk || rankNum <0)
        rankNum = numTrk;
    end

    figName = [figPath 'quality_plot_' plotType '_' rankingType];
    idxSeqSet = 1:length(seqs);

    %% draw and save the overall performance plot
    eval_res = plotDrawSave_pang(numTrk,plotDrawStyle,aveSuccessRatePlot,idxSeqSet,rankNum,rankingType,rankIdx,nameTrkAll,thresholdSet,titleName, xLabelName,yLabelName,figName,configPlot);
    fid = fopen([attrResPath '/' titleName '.txt'],'w');
    for idx = 1:numTrk
        fprintf(fid,'%s\t%s\n',eval_res{idx}{1},eval_res{idx}{2});
        result.(metricType).(eval_res{idx}{1}).all = str2double(eval_res{idx}{2});
    end
    fclose(fid);
    %% draw and save the performance plot for each attribute
    attTrld = 0;
    for attIdx = 1:attNum
        idxSeqSet = find(att(:,attIdx)>attTrld);
        if(length(idxSeqSet)<2)
            continue;
        end
        disp([attName{attIdx} ' ' num2str(length(idxSeqSet))])
        fid = fopen([attrSeqListPath '/' attName{attIdx} '.txt'],'w');
        for idx = 1:length(idxSeqSet)
            s = seqs{idxSeqSet(idx)};
            disp(s.name);
            fprintf(fid,'%s\n',s.name);
        end
        fclose(fid);
        figName = [figPath attFigName{attIdx} '_'  plotType '_' rankingType];
        titleName = ['Plots of ' evalType ': ' attName{attIdx} ' (' num2str(length(idxSeqSet)) ')'];

        switch metricType
            case 'overlap'
                 configPlot.location = 'southwest';
                titleName = ['Success plots of ' evalType ' - ' attName{attIdx} ' (' num2str(length(idxSeqSet)) ')'];
            case 'error'
                configPlot.location = 'southeast';
                titleName = ['Precision plots of ' evalType ' - ' attName{attIdx} ' (' num2str(length(idxSeqSet)) ')'];
        end

        eval_res = plotDrawSave_pang(numTrk,plotDrawStyle,aveSuccessRatePlot,idxSeqSet,rankNum,rankingType,rankIdx,nameTrkAll,thresholdSet,titleName, xLabelName,yLabelName,figName,configPlot);
        fid = fopen([attrResPath '/' titleName '.txt'],'w');
        for idx = 1:numTrk
            fprintf(fid,'%s\t%s\n',eval_res{idx}{1},eval_res{idx}{2});
            result.(metricType).(eval_res{idx}{1}).(attFigName{attIdx}) = str2double(eval_res{idx}{2});
        end
        fclose(fid);
    end
end
save("./evalRes/result.mat",'result');

close all;%pang-add