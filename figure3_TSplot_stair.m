% make TS diagram with data from the glacier front and rest of the CTD
% one panel per fjord

clear
clc
%% This scripts needs GSW package, must let Matlab know the folders are 
disk = ['/Users/sa07lc/Library/CloudStorage/OneDrive-SAMS/']; % mac
%disk = ['C:\Users\sa07lc\OneDrive - SAMS\']; %windows
    addpath([disk,'matlabF/GSW/'])
    addpath([disk,'matlabF/GSW/library/'])
    addpath([disk,'matlabF/GSW/thermodynamics_from_t/'])
% freezing line is caluclated with the GSW pacakge 

%%
isprint=0; RL=100;
% defining paths
dataPath=['../data/'];
here=pwd;
figPb=here; % path to save figures on
FZ=12;
set(0,'defaultaxesfontsize',FZ);
%% definitions for figures
regimes=1; % 1 for colouring the regimes
colorGF = 'k';
colorPlume='b';
colorRIVERs ='g';
colorFARs ='r';
lightgrey=[1.0000    0.7764    0.4969];
darkgrey = [0.3 0.3 0.3];

lineW=1.5;
msize=15; % size of marker for the water mass

fjords         ={'Flado','3Miippugut','Kivioq'};
glaciername    ={'ApuliliipApusiiaEast', 'Sorgenfri','RosenborgWest'};
stationtype    ={'GF','Far','river'};
netcdftypename ={'glacierfront','glacierfrontFAR','river'};

strprofiles = {'(a)','(b)', '(c)','(d)','(e)','(f)','(g)','(h)','(i)'};
fsubp = [1, 4, 7];
%% Water mass definition
% Add water masses as defined
% form station KR21061 at the entrance of Kangerlusuaq in Rysgaard et al. (2023, 10.1029/2023JC020665).
% at entrance of Kangerlusuaq KR21061
PWt1    = [-1.1];  PWs1 = [32]; %
% based on CTD16 (last station on every alongfjord.nc file)
AWt1    = [2.5];  AWs1 = [34.8]; %
AWit1   = [-1.5];  AWis1 = [33.5]; % based on CTD16 this is AW modified by ice (sits exactly along the gade line) 
salrange=25:35;
freezing = gsw_CT_freezing(salrange,100);
%% Make one figure with three panels.
close all
fig=figure; hold on
set(fig,'Position',[2.1643e+03 -237.6667 703 948]); % subplot 3,3

for f=1:3
    s1=subplot(3,3,fsubp(f)); hold on;  % i will have two additional subplots with profiles
    fjordname =fjords{f};

    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % load SDA CTD data  along fjord stations 
    filename    = [dataPath,'SDA_CTD_',glaciername{f},'_alongfjord.nc'];
    sdDIST = ncread(filename,'distance')'; %km
    sdSTNL  = ncread(filename,'fieldNo')'; % field station numner left to right 
    sdD     = double(ncread(filename,'depth')); %m
    sdlat   = double(ncread(filename,'latitude'));
    sdlon   = double(ncread(filename,'longitude'));
    sdRHO   = double(ncread(filename,'sigmat'));% potential density anomaly reference to -1000 kg/m3
    sdSA    = double(ncread(filename,'SA'));    %  absolute salinity psu
    sdCT   = double(ncread(filename,'CT'));    % conservative temperature C
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %    START TS plot - following theta_sdiag(theta,varnS,varnP)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % scatter CTD data from shelf/fjord entrance with color gradient
    NN=40; 
    sdDIST(sdDIST>40)=NN; edist = repmat(sdDIST, size(sdSA,1), 1); % these will help with plotting
    scatter(sdSA(:), sdCT(:), 7, log10(edist(:)), 'o','filled'); colormap(flip(copper))

    caxis(log10([0 NN]))
    %% load and plut erabus CTD glacier front
    clear *F *P *R
    % depth, station, distance, latitude, longitude
    filename    = [dataPath,'erabusCTD_profiles_',glaciername{f},'_glacierfront.nc'];
    ctddistance = ncread(filename,'distance')'; %km
    ctdSTNL     = ncread(filename,'station')'; % dummy number 1 to max number of stations.
    ctdSTNLf     = ncread(filename,'fieldNo')'; % field station number 
    ctddepth    = double(ncread(filename,'depth')); %m
    ctdlat      = double(ncread(filename,'latitude'));
    ctdlon      = double(ncread(filename,'longitude'));
    ctdN2       = double(ncread(filename,'N2'));    % "Brunt–Väisälä frequency
    ctdRHO     = double(ncread(filename,'sigmat'));% potential density anomaly reference to -1000 kg/m3
    ctdSA       = double(ncread(filename,'SA'));    %  absolute salinity psu
    ctdCT       = double(ncread(filename,'CT'));    % conservative temperature C
    ctdturbidity = double(ncread(filename,'turbidity')); % NTU
    % combine the data and interpolate along the distance and depth variables.

  
    if f==1
        % load far station
        filename     = [dataPath,'erabusCTD_profiles_',glaciername{f},'_glacierfrontFAR.nc'];
        ctddepthF    = double(ncread(filename,'depth')); %m
        ctdlatF      = double(ncread(filename,'latitude'));
        ctdlonF      = double(ncread(filename,'longitude'));
        ctdRHOF      = double(ncread(filename,'sigmat'));% potential density anomaly reference to -1000 kg/m3
        ctdSAF       = double(ncread(filename,'SA'));    %  absolute salinity psu
        ctdCTF    = double(ncread(filename,'CT'));    % conservative temperature C
        ctdturbidityF = double(ncread(filename,'turbidity')); % NTU
        % iceberg station
        pstn = [1];
        ctdSTNR = ctdSTNL(pstn);
        ctlatr = ctdlat(pstn);
        ctdlonR = ctdlon(pstn);
        ctdRHOR = ctdRHO(:,pstn);
        ctdSAR  = ctdSA(:,pstn);
        ctdCTR     = ctdCT(:,pstn);
        ctdturbidityR = ctdturbidity(:,pstn);
    end
    
    % select plume station
    if f==1;  pstn = [4];end
    if f==2;  pstn = [4,6]; end % ctd plume was the one in the picture I should made this blue in the map 
    if f==3;  pstn = 7:8; end
    ctdSTNP = ctdSTNL(pstn);
    ctlatP = ctdlat(pstn);
    ctdlonP = ctdlon(pstn);
    ctdRHOP = ctdRHO(:,pstn);
    ctdSAP  = ctdSA(:,pstn);
    ctdCTP     = ctdCT(:,pstn);
    ctdturbidityP = ctdturbidity(:,pstn);


    % plot the data on TS
    plot(ctdSA,ctdCT,'-','color',lightgrey,'linewidth',1)
    if exist('ctdSAF','var'); plot(ctdSAF,ctdCTF,'-','color',lightgrey,'linewidth',1); end
    %% load MSS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Data glacier front
    % depth, station, distance, latitude, longitude
    filename = [dataPath,'mss_profiles_',glaciername{f},'_glacierfront.nc'];
    depth    = double(ncread(filename,'depth')); %m
    distance = ncread(filename,'distance')'; %km
    STNL     = ncread(filename,'station')';
    lat      = double(ncread(filename,'latitude'));
    lon      = double(ncread(filename,'longitude'));
    %tmpN2    = double(ncread(filename,'N2'));    % "Brunt–Väisälä frequency
    tmpRHO   = double(ncread(filename,'sigmat'));% potential density anomaly reference to -1000 kg/m3
    tmpSA    = double(ncread(filename,'SA'));    %  absolute salinity psu
    tmpCT = double(ncread(filename,'CT'));    % conservative temperature C
    epsi     = double(ncread(filename,'log10eps'));
    %%%%%%%%% plume station  %%%%%%%%%%%%%%%%%%%%%%%
     if f==1; pstn = 4; end
     if f==2; pstn = 2; end
     if f==3; pstn = 4:6; end

    RHOP    = tmpRHO(:,pstn);
    SAP     = tmpSA(:,pstn);
    CTP     = tmpCT(:,pstn);
    EP      = epsi(:,pstn);
 

 
    if f<=2 % only two fjords have far and river/iceberg melt
        %%%%%%%%%%  FAR %%%%%%%%%%%%%%%%
        % Data FAR
        % depth, station, distance, latitude, longitude
        filename = [dataPath,'mss_profiles_',glaciername{f},'_glacierfrontFAR.nc'];
        depthF    = double(ncread(filename,'depth')); %m
        distanceF = ncread(filename,'distance')'; %km
        STNLF     = ncread(filename,'station')';
        latF      = double(ncread(filename,'latitude'));
        lonF      = double(ncread(filename,'longitude'));
        %  N2F    = double(ncread(filename,'N2'));    % "Brunt–Väisälä frequency
        RHOF   = double(ncread(filename,'sigmat'));% potential density anomaly reference to -1000 kg/m3
        SAF    = double(ncread(filename,'SA'));    %  absolute salinity psu
        CTF = double(ncread(filename,'CT'));    % conservative temperature C
        EF     = double(ncread(filename,'log10eps'));
           
        %%%%%%%%  RIVER   %%%%%%%%%%%%%
        % Data river
        % depth, station, distance, latitude, longitude
        filename  = [dataPath,'mss_profiles_',glaciername{f},'_river.nc'];
        depthR    = double(ncread(filename,'depth')); %m
        distanceR = ncread(filename,'distance')'; %km
        STNLR     = ncread(filename,'station')';
        latR      = double(ncread(filename,'latitude'));
        lonR      = double(ncread(filename,'longitude'));
        % N2R    = double(ncread(filename,'N2'));    % "Brunt–Väisälä frequency
        RHOR   = double(ncread(filename,'sigmat'));% potential density anomaly reference to -1000 kg/m3
        SAR    = double(ncread(filename,'SA'));    %  absolute salinity psu
        CTR = double(ncread(filename,'CT'));    % conservative temperature C
        ER     = double(ncread(filename,'log10eps'));
    end

  
    %%
    if regimes ==1
        % stations only along the graclier fonts.
        % combine all stations (TS plot with the full range of the data?
        if f==2
            CT        = [tmpCT, CTF,CTR];
            SA        = [tmpSA, SAF, SAR];
            RHO       = [tmpRHO, RHOF, RHOR];
            E         = [epsi, EF, ER];
         elseif f==1
            CT        = [tmpCT, CTF];
            SA        = [tmpSA, SAF];
            RHO       = [tmpRHO, RHOF];
            E         = [epsi, EF];
        elseif f==3
            CT        = [tmpCT];
            SA        = [tmpSA];
            RHO       = [tmpRHO];
            E         = [epsi];
         end
    else
        CT        = [tmpCT];
        SA        = [tmpSA];
        RHO       = [tmpRHO];
        E         = [epsi];
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    hold on
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % data at termini and regimes
    % scatter and plot TS data from MSS in the glacier front
    plot(SA,CT,'-','color',lightgrey,'linewidth',1.5)
    %%
    % plot the diferent regimes
    if regimes==1
            if exist('SAR','var'); plot(SAR,CTR,'-','Color',colorRIVERs,'LineWidth',lineW); end
        if exist('SAF','var'); plot(SAF,CTF,'-','Color',colorFARs,'LineWidth',lineW); end
        if exist('SAP','var'); plot(SAP,CTP,'-','Color',colorPlume,'LineWidth',lineW); end
        % % ctd data
        if exist('ctdSAP','var'); plot(ctdSAP,ctdCTP,'-','Color',colorPlume,'LineWidth',lineW); end

    end
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % add density contours 
    thetaTS=[-2:0.2:4];
    s=[24:0.5:35];

    smin=min(s)-0.01.*min(s);
    smax=max(s)+0.01.*max(s);
    thetamin=min(thetaTS)-0.1*max(thetaTS);
    thetamax=max(thetaTS)+0.1*max(thetaTS);
    xdim=round((smax-smin)./0.1+1);
    ydim=round((thetamax-thetamin)+1);
    dens=zeros(ydim,xdim);
    thetai=((1:ydim)-1)*1+thetamin;
    si=((1:xdim)-1)*0.1+smin;
    for j=1:ydim
        for i=1:xdim
            dens(j,i)=gsw_sigma0(si(i),thetai(j)); % LC modified potential density anomaly
        end
    end
    [c,h]=contour(si,thetai,dens,[20:1:28],'k');
    clabel(c,h,'LabelSpacing',90);
    if f==3; xlabel('SA (g kg^{-1})','FontWeight','normal','FontSize',FZ); end % only on the last
    ylabel('CT (^oC)','FontWeight','normal','FontSize',FZ)
    box on
    %%%%%%%%%%%%%%%%%%%%%%%%
    hold on
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plot water masses
     plot(AWs1, AWt1,'sk','markersize',msize,'MarkerEdgeColor','k','MarkerFaceColor','none')
     plot(PWs1 , PWt1, 'sk','markersize',msize,'MarkerEdgeColor','k','MarkerFaceColor','none')
     plot(AWis1 , AWit1, 'sk','markersize',msize,'MarkerEdgeColor','k','MarkerFaceColor','none')
    if strcmp(fjords{f},'Flado')
        ymin=-2.3; ymax=3.5;
        xmin=26; xmax=36;
        text (AWs1-1.5, AWt1,'AW','FontSize',FZ, 'FontWeight','normal', 'BackgroundColor','none')
        text (AWis1-1.5, AWit1-0.3,'MAW','FontSize',FZ, 'FontWeight','normal', 'BackgroundColor','none')
        text (PWs1-0.35,PWt1+.8,'PW','FontSize',FZ, 'FontWeight','normal', 'BackgroundColor','none')
    end
    if strcmp(fjords{f},'3Miippugut')
        ymin=-2.3; ymax=3.5;
        xmin=26; xmax=36;
        text (AWs1-1.5, AWt1,'AW','FontSize',FZ)
        text (AWis1-1.5, AWit1-0.3,'MAW','FontSize',FZ)
        text (PWs1-0.5,PWt1+.8,'PW','FontSize',FZ)
    end
    if strcmp(fjords{f},'Kivioq')
        ymin=-2.3; ymax=3.5;
        xmin=26; xmax=36;
        text (AWs1-1.5, AWt1,'AW','FontSize',FZ)
        text (AWis1-1.5, AWit1-0.3,'MAW','FontSize',FZ)
        text (PWs1-0.3,PWt1+.8,'PW','FontSize',FZ)
    end
     ylim([ymin ymax]);
     xlim([xmin xmax]);
    t0=text(xmin+0.3,ymax-0.5,[strprofiles{f},' ', glaciername{f}],'FontWeight','bold','FontSize',FZ); % add subplot letter
    %tn=title (glaciername{f});
    tn.FontWeight='normal'; tn.Position=[30.0219    1.5375    0.0000];
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% plot mixing lines %%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % the mixing lines : 
    lineWm=5;% width of the mixing line
    alpha=0.2; % transparency of mixing line
    linecolor=[0.5 0.5 0.5];
    % runoff line (T=0; S=0) and 
    % GADE line using gade_slope = 2.5;   % °C per salinity Hansen et al. 2025 https://www.nature.com/articles/s41561-025-01652-0
    [mTval] = min(min(tmpCT));
     mSval  = SA(tmpCT==mTval);
     gade_slope = 2.5;
     S_gade = linspace(AWs1, 30, 100);   % toward fresher water
     T_gade = AWt1 + gade_slope * (S_gade - AWs1);
   if f==1 
      plot([0 32],[-0.5 -1.1],'-','Color' , [linecolor alpha],'LineWidth',lineWm) % runoff PW
      plot([0 32],[1.5 -1.1] ,'-','Color' , [linecolor alpha],'LineWidth',lineWm) % SPG
      yp=[23.7 24.8]; % range in density of the plume
   elseif f==3  
       plot([0 33],[-0.5 -1.3],'-','Color', [linecolor alpha],'LineWidth',lineWm) % runoff PW
       plot([0 33],[1.5 -1.3],'-','Color' , [linecolor alpha],'LineWidth',lineWm) % SGP
      yp=[24.5 26.5]; % range in density of the plume

   elseif f==2;  
       plot([0 30.4],[-0.5 -1.1],'-','Color', [linecolor alpha],'LineWidth',lineWm) % runoff
       plot([0 30.4],[1.5 -1.1],'-' ,'Color', [linecolor alpha],'LineWidth',lineWm);% SGP
       yp=[22 23.5]; % range in density of the plume

   end
      plot(S_gade, T_gade, '-', 'Color', [linecolor alpha],'LineWidth',lineWm) % GADE line using slope

    plot(salrange,freezing,'-','Color', [linecolor alpha],'LineWidth',lineWm) % freezing line

        text(33.4, -0.5, 'Gade', 'FontSize', FZ, 'FontWeight','normal' ,'Color', [linecolor alpha],'BackgroundColor','none','Rotation',70)
        text(26.1, -1, 'runoff', 'FontSize', FZ, 'FontWeight','normal','Color', [linecolor alpha], 'BackgroundColor','none','Rotation',0)
        text(27.5, -0.5, 'SGP', 'FontSize', FZ, 'FontWeight','normal','Color', [linecolor alpha], 'BackgroundColor','none','Rotation',-1)
        t=text(28.5, -1.8, 'freezing', 'FontSize', FZ, 'FontWeight','normal','Color', [linecolor alpha], 'BackgroundColor','none','Rotation',-3);

   grid on
    %%
    %%%%%%%%%%%%%%%%%%%%
    % plotting  profiles energy disipation 
    %%%%%%%%%%%%%%%%%%%%
    hold off
    s2=subplot(3,3,fsubp(f)+1);
    yvar = 'RHO'; maxy=28; miny=21; % fix the y axis
    hold on
    stairs(E,eval(yvar),'color',lightgrey,'LineWidth',lineW); 
    if regimes==1
        if exist('SAP','var'); stairs(EP,eval([yvar,'P']),'color',colorPlume,'LineWidth',lineW); end
        if exist('SAR','var'); stairs(ER,eval([yvar,'R']),'color',colorRIVERs,'LineWidth',lineW); end
        if exist('SAF','var'); stairs(EF,eval([yvar,'F']),'color',colorFARs,'LineWidth',lineW); end
    end

     
    set(gca, 'XAxisLocation', 'top')
    set(gca,'YDir','reverse')
    if strcmp(yvar,'RHO')
        ylabel('\sigma_{\theta} (kg m^{-3})');
    else
        ylabel('Depth m');
    end
    if f==1;xlabel('Log_{10} \epsilon (W kg^{-1})');end
    xlim([-10 -4]) % fix to this range x because I want to compare between fjords
    xticks(gca, -10:2:-4)

    ylim([miny maxy]) % fix y range to each fjord because I want to line up properties across subplots.
    yticks(gca,miny:1:maxy);

    % gray patch along the plume density range 
     patch([-10 -4 -4 -10], ...
      [yp(1) yp(1) yp(2) yp(2)], ...
      [0.8 0.8 0.8], ... % gray color
      'EdgeColor','none', ...
      'FaceAlpha',0.4);  % transparency
    grid on
    t1=text(-9.8,miny+0.3,strprofiles{f+3},'FontWeight','bold','FontSize',FZ); % add subplot letter
    % plot a legend 
           if f==1 & regimes==1 % flado
               lg=legend({'','','','','','','','G','P','S','D'});
               lg.Location='best';
           end
           box on 
    %%%%%%%%%%%%%%%%%%%%
    % plotting  profiles other property defined in xvar below
    %%%%%%%%%%%%%%%%%%%%
    % turbidity
    s3=subplot(3,3,fsubp(f)+2);
    xvar ='ctdturbidity'; yvar='ctdRHO';
    plot(eval(xvar),eval(yvar),'-','color',lightgrey,'LineWidth',lineW); hold on
    if strcmp(xvar,'flc')||strcmp(xvar,'chla') % I can also plot the ctd data
        plot(eval(['ctd',xvar]),eval(['ctd',yvar]),'-','color',lightgrey,'LineWidth',lineW); hold on
    end
    if regimes==1
        if strcmp(xvar,'flu')||strcmp(xvar,'chla')
            if exist('SAR','var'); plot(eval([xvar,'R']),eval([yvar,'R']),'-','color',colorRIVERs,'LineWidth',lineW); end
            if exist('SAF','var'); plot(eval([xvar,'F']),eval([yvar,'F']),'-','color',colorFARs,'LineWidth',lineW); end
            if exist('SAP','var'); plot(eval([xvar,'P']),eval([yvar,'P']),'-','color',colorPlume,'LineWidth',lineW); end

            if exist('ctdSAF','var'); plot(eval(['ctd',xvar,'F']),eval(['ctd',yvar,'F']),'-','color',colorFARs,'LineWidth',lineW); end
            if exist('ctdSAP','var'); plot(eval(['ctd',xvar,'P']),eval(['ctd',yvar,'P']),'-','color',colorPlume,'LineWidth',lineW); end
          
        elseif strcmp(xvar,'ctdturbidity')
            if exist('ctdSAF','var'); plot(eval([xvar,'F']),eval([yvar,'F']),'-','color',colorFARs,'LineWidth',lineW); end
            if exist('ctdSAP','var'); plot(eval([xvar,'P']),eval([yvar,'P']),'-','color',colorPlume,'LineWidth',lineW); end
        end
    end
    set(gca, 'XAxisLocation', 'top')
    set(gca,'YDir','reverse')

    maxx = ceil(max(max(eval(xvar))));
    minx = floor(min(min(eval(xvar)))); % round down
    if strcmp(xvar,'flu')
        if f==1; xlabel('Flc RFU'); end;
        % temporary ploting theta has a place holder for turbidity
        minx =1; maxx=26;
        xticks(gca, minx:4:maxx)
    elseif strcmp(xvar,'chla')
        if f==1; xlabel('Chla \mug L^{-1}'); end;
        % temporary ploting theta has a place holder for turbidity
        minx =0; maxx=26;
        xticks(gca, minx:4:maxx)
    elseif strcmp(xvar,'ctdturbidity')
        if f==1;  xlabel('Turbidity (NTU)'); end;
    end

    xlim([minx maxx])
    ylim([miny maxy]) % fix y range to each fjord because I want to line up properties across subplots.
    yticks(gca,miny:1:maxy);
    grid on
    t2=text(minx+0.3,miny+0.3,strprofiles{f+6},'FontWeight','bold','FontSize',FZ); % add subplot letter
    % gray patch along the plume density range 
     patch([minx maxx maxx minx], ...
      [yp(1) yp(1) yp(2) yp(2)], ...
      [0.8 0.8 0.8], ... % gray color
      'EdgeColor','none', ...
      'FaceAlpha',0.4);  % transparency
    %%%%%%%%%%%%%%%%%%%%
    % resize the subplots
    ywidth=0.245; xwidth = ywidth+0.06; xpos = (xwidth)*(3-f+1-1)+0.06;
    s1.Position=[0.08 xpos 0.389 ywidth];
    s2.Position=[0.55 xpos 0.174 ywidth];
    s3.Position=[0.79 xpos 0.174 ywidth];
end % finish plotting this fjord
%% save
cb=colorbar; colormap(flip(copper));set(cb,'Orientation','horizontal'); 
cb.Position= [0.2444    0.9236    0.2199    0.0212];
caxis([log10(0) log10(120)]); 
cb.Ticks=[log10(1) log10(2) log10(10) log10(120)];
cb.TickLabels= {'0' ,'2', '10', num2str(NN)};
cb.Label.String = 'Distance from terminus (km)';
cb.Label.FontSize =12;
if isprint==1 & regimes==0
    exportgraphics(gcf,[figPb,'fig3_TSplot_profiles_3fjords','.png'],'Resolution',RL)
elseif isprint==1 & regimes==1
    exportgraphics(gcf,[figPb,'fig3_TSplot_profiles_3fjords_regimes_',xvar,'.png'],'Resolution',RL)
end

