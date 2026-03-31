%Paper figure 
% figure 1b. map g front with location of CTD, AUV, MSS stations, keep log10E sacling the size of the dot.
% uses functions select_stations.m
% plots the three glacier fronts as b c and d in a 2 by 2 subplot
% regimes and colours:
% Plume - blue, Glacier front (GF)- gray, Land runoff (R)- green, Far from GF (F) - red


%%

clear
clc
close all

isprint=0;RES=200;
%% define paths 

dataP=['../data/'];
here=pwd;
figP=here; % path to save figures on
%%
plotctd=1; plotauv=1; % if 1 it will plot ctd stations, and auv tracks
plotmean=0; % plot the mean of the regimes =1 or individual regimes 0 
emax=1;     % the size of the circles in the map will be: if =1 the max disipation in z, if =0 the mean energy disipation
eintg =0;   % do the integration of e (not log10(e)) over the water column for ingtD trapz(dz,epsiolon./insitudensity) W m-2 not the log10 eps
intgD = 60; 
fjords         = {'Flado','3Miippugut','Kivioq'}; % corresponding with glaicer names 
glaciername    ={'ApuliliipApusiiaEast', 'Sorgenfri','RosenborgWest'};
stationtype    ={'GF','Far','river'};
netcdftypename ={'glacierfront','glacierfrontFAR','river'};

addarrows=1; 

if emax==1 & eintg==0
fignameend = ['3fjords_','zemax'];
elseif emax==0 & eintg==0
fignameend = ['3fjords_','zemeann'];
elseif eintg==1
 fignameend = ['3fjords_','zintegral'];
end

%% define the colours for the figures 
colorGF = [0.8 0.8 0.8]; 
colorGFnoplume=[1.0000    0.7764    0.4969];
colorPlume='b';
colorR ='g';
colorF ='r';
lineW=1.5;
set(0,'defaultaxesfontsize',12);

%% define the line where data is projected to 
fjordGFboundaryLeft  = [67.877, -32.411; 68.286, -30.837; 68.471, -29.267 ];
fjordGFboundaryRight = [67.897, -32.340; 68.305,-30.778 ; 68.458, -29.232];



%% start reading and plotting 
fmap=figure; hold on
fmap.Position = [2.1283e+03 -236.3333 1.0373e+03 794]; 
for f=1:3
    fjordname =fjords{f};
    %dataP = [disk,'SDA041',slash,'MSS90-basil',slash,fjordname,slash,'Processed',slash];
    if f==1
        s1=subplot(2,2,1+f) ; hold on ;
        s1.Position =[0.5796 0.5753 0.3841 0.4006]; % make this one slightly larger
    elseif f==2
        s2=subplot(2,2,1+f) ; hold on ;
        s2.Position =[0.1030 0.0907 0.4133 0.4490]; % make this one slightly larger
    elseif f==3
        s3=subplot(2,2,1+f) ; hold on ;
        s3.Position =[0.6178 0.0964 0.3406 0.3973]; % make this one slightly larger
    end
 
    %% load erabus CTD 
    if plotctd==1
        clear ctdd* ctdl* ctdS*
    type='GF';n = find(strcmp(stationtype,type));
        filename     = [dataP,'erabusCTD_profiles_',glaciername{f},'_',netcdftypename{n},'.nc'];
        ctddistance  = ncread(filename,'distance')'; %km
        ctdSTNL      = ncread(filename,'station');
        ctddepth     = double(ncread(filename,'depth')); %m
        ctdlat       = double(ncread(filename,'latitude'));
        ctdlon       = double(ncread(filename,'longitude'));    
        if f==1 % Flado is the only one with a far station 
            type='Far'; n = find(strcmp(stationtype,type));
        filename     = [dataP,'erabusCTD_profiles_',glaciername{f},'_',netcdftypename{n},'.nc'];
        ctddistancef  = ncread(filename,'distance')'; %km
        ctdSTNLf      = ncread(filename,'station');
        ctddepthf     = double(ncread(filename,'depth')); %m
        ctdlatf       = double(ncread(filename,'latitude'));
        ctdlonf      = double(ncread(filename,'longitude'));   
        % iceberg station
        pstn = [1];
        ctddistancer  = ctddistance(pstn); %km
        ctdSTNLr      = ctdSTNL(pstn);
        ctddepthr     = ctddepth(pstn); %m
        ctdlatr       = ctdlat(pstn);
        ctdlonr      = ctdlon(pstn);   
        end 
        % plume stations 
          % select plume station to make blue crosses. 
          if f==1;  pstn = 4;end
          if f==2;  pstn = [4,6]; end % ctd plume was the one in the picture I should made this blue in the map 
          if f==3;  pstn = 7:8; end
        ctddistancep  = ctddistance(pstn); %km
        ctdSTNLp      = ctdSTNL(pstn);
        ctddepthp    = ctddepth(pstn); %m
        ctdlatp       = ctdlat(pstn);
        ctdlonp      = ctdlon(pstn);   
    end
    %% load AUV locations
    if plotauv==1
        clear auvd* auvl* auvS*
        type='GF';n = find(strcmp(stationtype,type));
        filename     = [dataP,'AUV_mission_',glaciername{f},'_',netcdftypename{n},'.nc'];
        auvdistance  = ncread(filename,'distance')'; %km
        auvdepth     = double(ncread(filename,'depth')); %m
        auvlat       = double(ncread(filename,'latitude'));
        auvlon       = double(ncread(filename,'longitude'));    
    end
%% load MSS data  
clear  stn2D*  sigT* depthall* mss* *depth* mssdistan* Ea*
% load MSS GF
type='GF';n = find(strcmp(stationtype,type));
filename    = [dataP,'mss_profiles_',glaciername{f},'_',netcdftypename{n},'.nc'];
mssdepth    = double(ncread(filename,'depth')); %m
mssdistance = ncread(filename,'distance')'; %km
mssSTNL     = ncread(filename,'station');
mssfieldNo  = ncread(filename,'fieldNo');
msslat      = double(ncread(filename,'latitude'));
msslon      = double(ncread(filename,'longitude'));
mssepsi     = double(ncread(filename,'log10eps'));
mssRHO      = double(ncread(filename,'sigmat'));% potential density anomaly reference to -1000 kg/m3
nm  = nan(size(mssepsi)); 
for ii=1:size(mssepsi,2); depth(:,ii) = mssdepth; end
%% step 2 Plume stations
type='Plume';
[STNp]=select_stations(fjordname,type);
if ~isempty(STNp)
    for ii=1:length(STNp)
        STNLp(ii) = find(mssfieldNo==STNp(ii));
    end
    % new station order
    for istn=1:length(STNp)
        ni = STNLp(istn);
        msslatp (istn)     = msslat(ni);
        msslonp(istn)      = msslon(ni);
        mssdistancep(istn) = mssdistance(ni);
    end
end
%% step 3  load river stations
type='river';n = find(strcmp(stationtype,type));
filename    = [dataP,'mss_profiles_',glaciername{f},'_',netcdftypename{n},'.nc'];
if exist(filename,'file')
    mssdepthr    = double(ncread(filename,'depth')); %m
    mssdistancer = ncread(filename,'distance')'; %km
    mssSTNLr     = ncread(filename,'station');
    msslatr      = double(ncread(filename,'latitude'));
    msslonr      = double(ncread(filename,'longitude'));
    mssepsir     = double(ncread(filename,'log10eps'));
    mssRHOr      = double(ncread(filename,'sigmat'));% potential density anomaly reference to -1000 kg/m3
    nm  = nan(size(mssepsir)); 
    for ii=1:size(mssepsi,2); depthr(:,ii) = mssdepthr; end
    for ii=1:size(mssSTNLr,1);mssSTNLrstring {ii}= ['R',num2str(mssSTNLr(ii))];  end
end
%% step4 load distal stations
type='Far'; n = find(strcmp(stationtype,type));
filename    = [dataP,'mss_profiles_',glaciername{f},'_',netcdftypename{n},'.nc'];
if exist(filename,'file')
    mssdepthf    = double(ncread(filename,'depth')); %m
    mssdistancef = ncread(filename,'distance')'; %km
    mssSTNLf     = ncread(filename,'station');
    msslatf      = double(ncread(filename,'latitude'));
    msslonf      = double(ncread(filename,'longitude'));
    mssepsif     = double(ncread(filename,'log10eps'));
    mssRHOf      = double(ncread(filename,'sigmat'));% potential density anomaly reference to -1000 kg/m3
    nm           = nan(size(mssepsif)); 
    for ii=1:size(mssepsi,2); depthf(:,ii) = mssdepthf; end
end
%% %%  map of the station
type='all';
if exist('msslonf','var') & exist('msslonr','var')
    %combine GF + F + R
    STNall   = [mssSTNL; mssSTNLf; mssSTNLr];
    Eall     = [mssepsi, mssepsif, mssepsir];
    depthall = [depth,   depthf,   depthr];
    latall   = [msslat; msslatf; msslatr];
    lonall   = [msslon; msslonf; msslonr];
    sigTall  = [mssRHO, mssRHOf, mssRHOr];
elseif exist('msslonf','var') & ~exist('msslonr','var')
    % combine GF + F
    STNall   = [mssSTNL; mssSTNLf];
    Eall     = [mssepsi, mssepsif];
    depthall = [depth,   depthf];
    latall   = [msslat; msslatf];
    lonall   = [msslon; msslonf];
    sigTall  = [mssRHO, mssRHOf];
else 
    % only GF 
    STNall   = mssSTNL;
    Eall     = mssepsi;
    depthall = depth;
    latall   = msslat;
    lonall   = msslon;
    sigTall  = mssRHO;
end
%% Step1 MAP calculate the metric to be plotted
% prepare with a single variable name
if emax==0 & eintg==0
    % geometric mean - m2/s3 (0.5 = thickness of the depth bins % W /kg
    tmp=nansum(10.^Eall.*0.5,1)./max(depthall); % the geometric mean
    myvar = log10(tmp);
    pvar = normalize(myvar,'range',[0.1 1]); % normalize the data
    textboxtit = 'Log_{10}(mean(\epsilon)) W kg^{-1}';
elseif emax==1 & eintg==0
    % the maximum in the profile
    myvar = max(Eall); % the maximum in the profile plume areas % W/ kg
    pvar = normalize(myvar,'range',[0.1 1]); % normalize the data
    textboxtit = 'Max Log_{10}(\epsilon) W kg^{-1}';
elseif eintg==1
    % the integral of the profile
    mD=length(2.5:0.5:intgD); tmp = (10.^Eall(1:mD,:))./(1000+sigTall(1:mD,:));
    if sum(sum(isnan(tmp)))>0
        % if the profile does not extend to intgD there will be nan and we need
        % to make the nan 0 to avoid errors in the trapz function.
        dindx = find(isnan(tmp),1);
        Dlim = depthall(dindx-1);
        tmp(isnan(tmp))=0;  % fill with zero where there is nan.
         % kivioq has an issue with station 1 which only has depth 37.5m
    end
    myvar = log10(trapz(0.5,tmp,1)); % w m-2 log ten of the integral
    textboxtit='Log_{10}(\int_z\epsilon) W m^{-2}';
end
    pvar = normalize(myvar,'range',[0.1 1]); % normalize the dat
    [n markerL] = max(pvar);
    Lmarkerval = myvar(markerL);
    [n markerS] = min(pvar);
    Smarkerval = myvar(markerS);
    [n] = median(pvar); [x markerM]= min(abs(pvar-n));
    Mmarkerval =myvar(markerM);

%% Make the map
MAG=200;

% legend and station numbers depending on fjords 
if strcmp(fjordname,'3Miippugut') 
    latup =0.002;
    latlon1=[68.3,-30.82];% origine
    latlon2=[68.3,-30.81]; % desitination
    [d1km, d2km]=lldistkm(latlon1,latlon2);
    latstr=latlon1(1)+latup;
%%
         %or plot the tiff image
        flname2 = [dataP,'Sorgenfri_2024-08-02-00_00_2024-08-02-23_59_Sentinel-2_L2A_True_color.TIFF'];flname=[flname2];
        [A,R] = readgeoraster(flname); [lat_tiff,lon_tiff] = geographicGrid(R);
        g=geoshow(lat_tiff,lon_tiff,A);
        uistack(g,'down');
    
    axis manual % prevents autoscaling
        xlim([-30.88 -30.75])
        ylim([68.272 68.3055])
    rx = [30.877  30.831]; ry= [68.295 68.3051];
    rn=rectangle('Position',[-rx(1) ry(1) rx(1)-rx(2) ry(2)-ry(1)], 'FaceColor','w','edgecolor','k');uistack(rn,'up'); % position (x, y, w, h)
    text(-30.873,68.3035,textboxtit)
    
    scatter(-30.872,68.3005,pvar(markerL)*MAG,colorGF,'filled','MarkerEdgecolor','k');
    text   (-30.867,68.3005,[' ',num2str(round(Lmarkerval,2))])
    scatter(-30.872,68.298,pvar(markerM)*MAG,colorGF,'filled','MarkerEdgecolor','k');
    text   (-30.867,68.298,[' ',num2str(round(Mmarkerval,2))])
    scatter(-30.872,68.296,pvar(markerS)*MAG,colorGF,'filled','MarkerEdgecolor','k');
    text   (-30.867,68.296,[' ',num2str(round(Smarkerval,2))])

elseif strcmp(fjordname,'Kivioq')
    latup =0.001;
    latlon1=[68.466,-29.24];% origine
    latlon2=[68.466,-29.230]; % desitination
    [d1km, d2km]=lldistkm(latlon1,latlon2);
    latstr=latlon1(1)+latup;
   
        %or plot the tiff image
        flname2 = [dataP,'RosenborgWest_2024-08-08-00_00_2024-08-08-23_59_Sentinel-2_L2A_True_color.TIFF'];flname=[flname2];

        [A,R] = readgeoraster(flname); [lat_tiff,lon_tiff] = geographicGrid(R);
        g=geoshow(lat_tiff,lon_tiff,A);
        uistack(g,'down');
 
    axis manual % prevents autoscaling
     xlim([-29.266 -29.228])
     ylim([68.45825 68.473])
     rx = [29.243]; xwidth= 0.0145; ry= [68.4685]; ywidth=0.0043;
     rn=rectangle('Position',[-rx ry xwidth ywidth], 'FaceColor','w','edgecolor','k');uistack(rn,'up'); % position (x, y, w, h)
     text(-29.2425,68.4721,textboxtit)
    
    scatter(-29.241,68.4708,pvar(markerL)*MAG,colorGF,'filled','MarkerEdgecolor','k');
    text(-29.239,68.4708,[' ',num2str(round(Lmarkerval,2))])
    scatter(-29.241,68.4697,pvar(markerM)*MAG,colorGF,'filled','MarkerEdgecolor','k');
    text(-29.2395,68.46979,['  ',num2str(round(Mmarkerval,2))])
    scatter(-29.241,68.4690,pvar(markerS)*MAG,colorGF,'filled','MarkerEdgecolor','k');
    text(-29.239, 68.4690,[' ',num2str(round(Smarkerval,2))])

elseif strcmp(fjordname, 'Flado')
    latup =0.0015;
    latlon1=[67.885,-32.41];% origine
    latlon2=[67.885,-32.40]; % desitination
    [d1km, d2km]=lldistkm(latlon1,latlon2);
    latstr=latlon1(1)+latup;
    
        %or plot the tiff image
        flname2 = [dataP,'ApuliliipApusiiaEast_2024-08-24-00_00_2024-08-24-23_59_Sentinel-2_L2A_True_color.TIFF'];
        flname=[flname2];
        [A,R] = readgeoraster(flname); [lat_tiff,lon_tiff] = geographicGrid(R);
        g=geoshow(lat_tiff,lon_tiff,A);
        uistack(g,'down');   
 
    axis manual % prevents autoscaling
    xlim([-32.416 -32.32])
    ylim([67.872 67.90])

   
    % put in Legend
    rx = [32.4145  32.381]; ry= [67.891 67.8996];
    rn=rectangle('Position',[-rx(1) ry(1) rx(1)-rx(2) ry(2)-ry(1)], 'FaceColor','w','edgecolor','k');uistack(rn,'up'); % position (x, y, w, h)
    text(-32.4142,67.898,textboxtit)
 
    scatter (-32.41,67.8957,pvar(markerL)*MAG,colorGF,'filled','MarkerEdgecolor','k');
    text    (-32.405,67.8957,[' ',num2str(round(Lmarkerval,2))])
    scatter (-32.41,67.8935,pvar(markerM)*MAG,colorGF,'filled','MarkerEdgecolor','k');
    text    (-32.405,67.8935,[' ',num2str(round(Mmarkerval,2))])
    scatter (-32.41,67.892,pvar(markerS)*MAG,colorGF,'filled','MarkerEdgecolor','k');
    text    (-32.405,67.892,[' ',num2str(round(Smarkerval,2))])
end
%% plot AUV track 
if plotauv==1
    clear ulonlat k subset
    ulonlat = [auvlon,auvlat];
    alpha=0.3;
    if strcmp(fjordname, 'Flado')
    % % mAKE polygon around the data collection, it looks good in Flado
    % where the sampling was done metodically inside the polygon 
   % %  k = convhull(ulonlat(:,1),ulonlat(:,2));
   % % % Plot shaded area
   % %  fill(ulonlat(k,1), ulonlat(k,2), [0.6 0.8 1], 'EdgeColor', 'none','FaceAlpha', 0.3);  % light blue fill
   % %  % if the area is too big I may need to redfine the 90% closest poits 
    % Compute distances from centroid
     centroid = mean(ulonlat,1);
     dists = sqrt(sum((ulonlat - centroid).^2, 2));
     % Find threshold for 90% of points closest
     thresh = prctile(dists, 100);
     % Select points inside threshold
     subset = ulonlat(dists <= thresh, :);
     % Compute hull on subset
     k = convhull(subset(:,1), subset(:,2));
    fill(ulonlat(k,1), ulonlat(k,2), [0.6 0.8 1], 'EdgeColor', 'none','FaceAlpha', alpha);  % light blue fill
    % plot(subset(k,1), subset(k,2), 'b.') % plots the points outside
    scatter(ulonlat(:,1),ulonlat(:,2),0.1,[0.6 0.8 1],'filled','MarkerFaceAlpha',alpha)
    elseif strcmp(fjordname, 'Kivioq')
          scatter(ulonlat(:,1),ulonlat(:,2),0.4,[0.6 0.8 1],'filled','MarkerFaceAlpha',alpha+0.3)
    end
    % no data in 3miippugut
end
%% MSS plot circles of normalized E
hold on
sc=scatter(lonall,latall,pvar*(MAG),colorGF,'filled','MarkerFaceAlpha',0.7,'MarkerEdgecolor','k'); hold on
% add triangles for scale around the circles of E  colour follows regimes  
scatter(msslon,msslat,MAG*2,colorGFnoplume,'v','LineWidth',lineW); hold on
scatter(msslonp,msslatp,MAG*2,colorPlume,'v','LineWidth',lineW); hold on
if exist('msslonr','var'); scatter(msslonr,msslatr,MAG*2,colorR,'v','LineWidth',lineW); end
if exist('msslonf','var'); scatter(msslonf,msslatf,MAG*2,colorF,'v','LineWidth',lineW);end
%% plot ctd data as crosses 
if plotctd==1
    plot(ctdlon,ctdlat,'pk','MarkerSize',10,'MarkerFacecolor',colorGFnoplume)
    if exist('ctdlonf','var'); plot(ctdlonf,ctdlatf,'pk','Markersize',10,'MarkerFacecolor',colorF);end
    if exist('ctdlonr','var'); plot(ctdlonr,ctdlatr,'pk','Markersize',10,'MarkerFacecolor',colorR);end
    if exist('ctdlonp','var'); plot(ctdlonp,ctdlatp,'pk','Markersize',10,'MarkerFacecolor',colorPlume);end
end

%% scale vector 
plot([latlon1(2) latlon2(2)], [latlon1(1) latlon2(1)],'-k','linewidth',3) 
text(latlon1(2),latstr,[num2str(round(d1km*1000)), 'm'])


xlabel('Longitude')
ylabel('Latitude')
box on
grid on 


% add SDA CTD crosses to see which one is close to the front 
%plot(ctd_lon,ctd_lat,'r+');
end
% fignameend contains fjord name and wether scatter plot has dissipation or
% not 
if isprint==1 
  if isline==1;    exportgraphics(gcf,[figP,'fig1_map_E_regimes_',fignameend,'.png'],'Resolution',RES)
  else ; exportgraphics(gcf,[figP,'fig1_mapImage_E_regimes_',fignameend,'.jpeg'],'Resolution',RES); end 
end