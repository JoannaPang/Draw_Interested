close all;
clear, clc;
warning off all;
addpath(genpath('.')); 

%% path config
% datasetPath = '/home/tony/app/ACT/dataset/data_sot/'; % the dataset path
% seqs = configSeqs(fullfile(datasetPath,'sequences'), 'test_seqs.txt'); % the set of sequences
% annoPath = fullfile(datasetPath, 'annotations');

% datasetPath = '/home/tony/app/ACT/dataset/data_sot/'; % the dataset path
datasetPath = '/data/data/swfcode/matlab/Vital_release-master/dataset/dtbuav/'
% seqs = configSeqs(fullfile(datasetPath,'sequences'), 'test_seqs.txt'); % the set of sequences
seqs = configSeqs(fullfile(datasetPath,'seq'), 'uav_seq1.txt'); 
annoPath = fullfile(datasetPath, 'anno/');

evalType = 'OPE'; % the evaluation type such as 'OPE','SRE','TRE'
resultPath = ['./results/results_' evalType '/'];
trackers = {
            struct('name','rcac100_uavdtb','namePaper','CRAC-mdnet')
            struct('name','simplemul_uavdtb','namePaper','CRAC_siam')
            struct('name','meta_crest_uavdtb','namePaper','meta_crest')
            %struct('name','rcac20','namePaper','CRAC2')
            struct('name','siamFC_uavdtb','namePaper','siamFC')
            %struct('name','rcac80','namePaper','CRAC8')
            struct('name','act_uavdtb','namePaper','ACT')
            struct('name','adnet_uavdtb','namePaper','ADNET')
            struct('name','mdnet_uavdtb','namePaper','MDNET')
            struct('name','vital_uavdtb','namePaper','VITAL')
            struct('name','STRCF_uavdtb','namePaper','STRCF')     
            %struct('name','rcac_uav','namePaper','CRAC')
            %struct('name','rcac50','namePaper','CRAC5')
            struct('name','MCCT_uavdtb','namePaper','MCCT')
            struct('name','meta_sdnet_uavdtb','namePaper','meta_sdnet')
            struct('name','orisiamrpn_uavdtb','namePaper','siamRPN')
           
            }; % the set of trackers
% evalType = 'OPE'; % the evaluation type such as 'OPE','SRE','TRE'
% resultPath = ['./results/results_' evalType '/'];
% trackers = {
            % struct('name','ACT','namePaper','ACT')
            % struct('name','GT','namePaper','GT')
            % struct('name','adnet','namePaper','ADNet')
            % struct('name','sdnet','namePaper','meta-SDNet')
            % }; % the set of trackers

attrPath = fullfile(datasetPath, 'attributes');  % the folder that contains the annotation files for sequence attributes
attName = {'Aspect Ratio Change','Background Clutter','Camera Motion','Fast Motion','Full Occlusion','Illumination Variation','Low Resolution',...
           'Out-of-View','Partial Occlusion','Similar Object','Scale Variation','Viewpoint Change'};
attFigName = {'Aspect_Ratio_Change','Background_Clutter','Camera_Motion','Fast_Motion','Full_Occlusion','Illumination_Variation','Low_Resolution',...
           'Out-of-View','Partial_Occlusion','Similar_Object','Scale_Variation','Viewpoint_Change'};

% configPlot.FontName = 'Times New Roman';
% configPlot.FontSize = 20;
% configPlot.FontWeight = 'bold';
% %% plot config     
% configPlot.fontSize = 26;
% configPlot.fontSizeLegend = 24;
% configPlot.lineWidth = 6;
% configPlot.fontSizeAxes = 20;




% %%pang-add
configPlot.FontName = 'Times New Roman';
configPlot.FontSize = 16;
configPlot.FontWeight = 'bold';
%% plot config     
configPlot.fontSize = 15;
configPlot.fontSizeLegend = 12;
configPlot.lineWidth = 4;
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

% att = [];
% for idxSeq = 1:numSeq
%     s = seqs{idxSeq};
%     nameSeqAll{idxSeq} = s.name;    
%     s.len = s.endFrame - s.startFrame + 1;
%     numAllSeq(idxSeq) = s.len;
%     att(idxSeq,:) = load([attrPath '/' s.name '_attr.txt']);
% end

%attNum = size(att,2);

figPath = './figs/overall/';

perfMatPath = './perfMat/overall/';

if ~exist(figPath,'dir')
    mkdir(figPath);
end

metricTypeSet = {'overlap','error'};

rankNum = -1;%number of plots to show------------------------------------------------------------------------
%plotDrawStyle = getDrawStyle(rankNum);
plotSetting_pang;%pang-fix

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
            titleName = ['Precision plots of ' evalType];
            configPlot.location = 'southeast';
    end
    disp(titleName);
    
    dataName = [perfMatPath 'aveSuccessRatePlot_' num2str(numTrk) 'alg_'  plotType '.mat'];

    % If the performance Mat file, dataName, does not exist, it will call genPerfMat to generate the file.
    if(~exist(dataName, 'file') || reEvalFlag)
        genPerfMat(annoPath, seqs, trackers, evalType, resultPath, nameTrkAll, perfMatPath);
    end        

    load(dataName);
    numTrk = size(aveSuccessRatePlot,1);        
    if(rankNum > numTrk || rankNum <0)
        rankNum = numTrk;
    end

    figName = [figPath 'quality_plot_' plotType '_' rankingType];
    idxSeqSet = 1:length(seqs);

    %% draw and save the overall performance plot
    plotDrawSave_pang(numTrk,plotDrawStyle,aveSuccessRatePlot,idxSeqSet,rankNum,rankingType,rankIdx,nameTrkAll,thresholdSet,titleName, xLabelName,yLabelName,figName,configPlot);
    
    %% draw and save the performance plot for each attribute
    attTrld = 0;
 %   for attIdx = 1:attNum
%         idxSeqSet = find(att(:,attIdx)>attTrld);
%         if(length(idxSeqSet)<2)
%             continue;
%         end
%         disp([attName{attIdx} ' ' num2str(length(idxSeqSet))])
% 
%         figName = [figPath attFigName{attIdx} '_'  plotType '_' rankingType];
%         titleName = ['Plots of ' evalType ': ' attName{attIdx} ' (' num2str(length(idxSeqSet)) ')'];
% 
%         switch metricType
%             case 'overlap'
%                 titleName = ['Success plots of ' evalType ' - ' attName{attIdx} ' (' num2str(length(idxSeqSet)) ')'];
%                 configPlot.location = 'southwest';
%             case 'error'
%                 titleName = ['Precision plots of ' evalType ' - ' attName{attIdx} ' (' num2str(length(idxSeqSet)) ')'];
%                 configPlot.location = 'southeast';
%         end
% 
%         plotDrawSave(numTrk,plotDrawStyle,aveSuccessRatePlot,idxSeqSet,rankNum,rankingType,rankIdx,nameTrkAll,thresholdSet,titleName, xLabelName,yLabelName,figName,configPlot);
%     end
end
