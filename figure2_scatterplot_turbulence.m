% scatter plot of Emax, depth of max
%%
clear
clear all
clc
close all
FZ=14;
%% define paths

dataP=['../data/'];
here=pwd;
figP=here; % path to save figures on
set(0,'defaultaxesfontsize',FZ);
%% other definitions
savefig=0;
addlit=0; % adds literature values 
isfig=1; if isfig==1; fg=figure; end %plots the section figure
set(fg,'Position',[90 325 527 325])
if addlit==1; figname='fig2_scatter_turbulence_with_lit';
else; figname='fig2_scatter_turbulence'; end

fjords         ={'Flado','3Miippugut','Kivioq'};
glaciername    ={'ApuliliipApusiiaEast', 'Sorgenfri','RosenborgWest'};
netcdftypename ={'Plume','glacierfront','glacierfrontFAR','river'};
fmarker = {'v','o','s'};
%% define the colours for the figures 
colorGF = [0.8 0.8 0.8]; 
colorGF=[1.0000    0.7764    0.4969];
colorPlume='b';
colorR ='g';
colorF ='r';
colortype={colorPlume,colorGF,colorF,colorR};
%% start the loop of the glaciers and regime type
for myvar=1:2 % loop the two variables. 
myvarstr={'\epsilon_{max}','K_z_{,max}'}; myvarunit = {'W kg^{-1}','m^2 s^{-1}'};
hold off; subplot(1,2,myvar); hold on
for ff=1:length(fjords)
 if ff==3; ttn=2; else; ttn=4;end
for tt=1:ttn % three defined regimes.
     netcdftype = netcdftypename{tt};
    if tt==1; netcdftype = netcdftypename{2}; end
   
%% maximum depth of epsilon on the plume station
mssncfilename = [dataP,'mss_profiles_',glaciername{ff},'_',netcdftype,'.nc'];
log10eps  = double(ncread(mssncfilename,'log10eps'));
Kz        = log10(double(ncread(mssncfilename,'Kz')));
mssdepth    = double(ncread(mssncfilename,'depth')); %m
mssdistance  = ncread(mssncfilename,'distance')';% km along the merged glacier front section
if myvar==1
[maxvar maxidx]=max(log10eps);
depthEmax = round(mssdepth(maxidx));
elseif myvar==2
[maxvar maxidx]=max(Kz);
depthEmax = round(mssdepth(maxidx));
end
%% In the case of GF we have to separate plume stations and the iceberg melt 
 GFidx=1:size(Kz,2);
    if strcmp(netcdftypename{tt},'glacierfront')
        if strcmp(fjords{ff},'Flado')% I need to remove plume stations and river stations
            GFidx = [2,3,5,6,7];
        elseif strcmp(fjords{ff},'3Miippugut') % i need to remove plume stations
            GFidx = [1,3:7];
        elseif strcmp(fjords{ff},'Kivioq') % i need to remove plume stations
            GFidx = [1,2,3];
        end
    end
    if strcmp(netcdftypename{tt},'Plume')
        if strcmp(fjords{ff},'Flado')
            GFidx = [4];% plume stations
        elseif strcmp(fjords{ff},'3Miippugut')
            GFidx = [2];%plume station
        elseif strcmp(fjords{ff},'Kivioq')
            GFidx = [4,5,6];%plume stations
        end
    end
    %% plot and hold it
scatter(maxvar(GFidx),depthEmax(GFidx),200,fmarker{ff},'MarkerEdgeColor', 'k','MarkerFaceColor',colortype{tt})
hold on
end %tt
end %ff
%% add literature values 
enviroments = {'iceshelfedge','openocean','underice','miz','R','GF','F'};
if myvar==1
    lbl = ['(a) log_{10} ',myvarstr{myvar},' (',myvarunit{myvar},')'];
   % epsilon log 10
   value =[1,2,3,4,7,8];
   % fjord river
   lit.R = [-3];val.R ={'1'};%1
   %fjord glacier front
   lit.GF =[-6];val.GF={'2'};%2
   % fjord iceshelf edge 
   lit.iceshelfedge=[-9,-8,-7,-7];val.iceshelfedge={'3','4','5','6'};%3,4,5,6
   % fjord background
   lit.F =[-8, -9]; val.F={'7','8'};%7,8 
   % open ocean and shelf
   lit.openocean =[-7 -9]; val.openocean={'9'}; %9
   % under ice
   lit.underice =[-9,-5,-6,-8]; val.underice={'10','11','12','13'};
   % marginal ice zone
   lit.miz = [-4, -6];val.miz={'11','14'};
elseif myvar==2
    lbl = ['(b) log_{10} ',myvarstr{myvar},' (',myvarunit{myvar},')'];

    %kz log 10
    % river
    lit.R=[];val.R={};
    % fjord glacier front
    lit.GF=[]; val.GF={};
    % ice shelf edge
    lit.iceshelfedge = [-2,-2];val.iceshelfedge={'5','6'};
    % fjord background
    lit.F = [-5]; val.F={'8'};
    % open ocean
    lit.openocean =[-4]; val.openocean={'9'}; %9
    % under ice 
    lit.underice =[-4]; val.underice={'10'}; %10
    % marginal ice zone 
    lit.miz = [];val.miz={};
end
%value is literautre number 
%1 McPherson et al. 2020 https://doi.org/10.5194/os-16-799-2020
%2 Inall et al. 2024 
%3 Inall et al. 2021
%4 Fer et al. 2012
%5 Dotto et al. 2025
%6 Garabato et al. 2017
%7 Bendtsen et al. (2021)
%8 Arneborg et al. (2004)
%9 Sugiura et al., 2018, 10.5194/npg-25-219-2018Jaime?
%10 Fine & Cole, 2022, 10.1029/2021JC018056
%11 Smith & Thomson, 2019 
%12 Fer et al. (2022)
%13 Fer and Sundfjord (2007)
%14 Sundfjord et al. (2007)
%15 Becherer et al. 2022 

%% plot the extras along a depth 0 
if addlit==1
for ii=5:length(enviroments)
    varstr=enviroments{ii};
    eval(['mylitvar=lit.',varstr,';'])
    eval(['mylitval=val.',varstr,';'])
    mylitdepth = zeros(size(mylitvar));mylitdepth(:)=120;
    if strcmp(varstr,'R')
        scatter(mylitvar,mylitdepth,200,'p','MarkerEdgeColor', 'k','MarkerFaceColor',colorR)
    elseif strcmp(varstr,'F')
        scatter(mylitvar,mylitdepth,200,'p','MarkerEdgeColor', 'k','MarkerFaceColor',colorF)
    elseif strcmp(varstr,'GF')
        scatter(mylitvar,mylitdepth,200,'p','MarkerEdgeColor', 'k','MarkerFaceColor',colorGF)
    else
        scatter(mylitvar,mylitdepth,220,'p','MarkerEdgeColor', 'k','MarkerFaceColor','k')
    end
    text(mylitvar,mylitdepth+5,mylitval)
end
end

%% make the figure pretty 
box on 
ylim([0 120])
ylabel('Depth (m)')
xlabel([lbl])
set(gca, 'XAxisLocation', 'top')
set(gca,'YDir','reverse')
grid on 
end % var loop
if savefig==1; exportgraphics(gcf, [figPp,figname,'.jpg'], 'Resolution', 300); end
