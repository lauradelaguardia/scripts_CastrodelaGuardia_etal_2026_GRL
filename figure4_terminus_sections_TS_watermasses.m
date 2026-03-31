% plot the section of the merged data produced with
% write_merged_section_data_ondepth.m
% calculate heat content and define water masses.
%%
clear
clear all
clc
close all
FZ=12; 
set(0,'defaultaxesfontsize',FZ);
%% define paths 
dataP=['../data/'];
here=pwd;
figP=here; % path to save figures on

%% define 
isfig=1; if isfig==1; fg=figure; end %plots the section figure
savefig=0; 
RL=100; % resolution of figure
% can give up to 3 variables
varplot={'CT','SA','WM'};


fjords         ={'Flado','3Miippugut','Kivioq'};
glaciername    ={'ApuliliipApusiiaEast', 'Sorgenfri','RosenborgWest'};
stationtype    ={'GF'};
netcdftypename ={'glacierfront'};
% variabels in the netcdf file
varlist        ={'latitude','longitude','depth','distance','stationL', 'stationNo','CT','SA','RHO'};
varunits      = {'N'  , 'W', 'm' , 'km', 'km', '', '\circC', 'g kg^{-1}','kg m^{-3}'};
varLongNames = {'Conservative Temperature', ...
    'Absolute Salinity', ...
    'Potential density anomaly ref. 1000 kg/m3'};%,...
%%
letterplot = {'(a)', '(b)', '(c)','(d)','(e)','(f)','(g)','(h)','(i)'};
letterpos  = [3.2 ,185; 2.8 ,185 ; 2.00 ,185];
%% load merged data
clf % clera figure
set(0,'defaultaxesfontsize',FZ); % sets the fontsize for all figures.

set(fg,"Position",[13 79 840 588]) 
count=0; % keep a count for subplot axes definition of colormap
for f=1:length(fjords)
    %% open merged data ncfile 
    filename     = [dataP,'merged_data_',glaciername{f},'_',netcdftypename{1},'.nc'];
    for var=1:length(varlist)
        eval([varlist{var},'= ncread(''',filename,''',''',varlist{var},''');']);
    end
    depth2D= repmat(depth,1,size(distance,1));
    %% maximum depth of epsilon on the plume station
    mssncfilename = [dataP,'mss_profiles_',glaciername{f},'_',netcdftypename{1},'.nc'];
    log10eps  = double(ncread(mssncfilename,'log10eps'));
    mssdepth    = double(ncread(mssncfilename,'depth')); %m
    mssdistance  = ncread(mssncfilename,'distance')';% km along the merged glacier front section 
    [maxeps maxepsidx]=max(log10eps);
    normE = normalize(maxeps,'range',[1 2]).*10;
    depthEmax = round(mssdepth(maxepsidx));
   
    %% watermass clasification as in Figure2TSplot_stairs.m + aditional modification range
    % Add water masses as defined
    % form station KR21061 at the entrance of Kangerlusuaq in Rysgaard et al. (2023, 10.1029/2023JC020665).
    % at entrance of Kangerlusuaq KR21061
    PWt1    = [-1.1];  PWs1  = [32]; %
    AtWt1   = [1.3];   AtWs1 = [34.8]; %
    % follow Inall et al 2014  to name and define modified water masses
    % modified Polar Surface Water  PW RHO<27.7
    % warmed Polar Surface Water PSWw RHO<27.7 CT>0
    % Polar Intermidiate Water PIW RHO > 27.7 CT<0
    % AW 34 < SA <34.8
    WMs = ones(size(CT)); % Class 6 neither PW or AW
    WMs(WMs==1)=7; % Unclasified water FW
    if strcmp(fjords{f},'Kivioq')
        SAinf=33.2; % salinity at the infliction point on TS space
    elseif  strcmp(fjords{f},'Flado')
        SAinf=32.5; % salinity at the infliction point on TS space
    elseif  strcmp(fjords{f},    '3Miippugut')
        SAinf=32; % salinity at the infliction point on TS space
    end
    WMs(CT>=0  & SA>SAinf)=2; % Cass 1 modified Atlantic Water AWw
    WMs(CT<0   & SA>SAinf)=3; % Cass 3 MAWc
    WMs(CT< 0  & SA<=SAinf)=5; % Cass 5  PW
    WMs(CT<=-1.4)=4; % Class 4 PWc
    WMs(CT>0 & SA<=SAinf)=6; % Cass  PWw
    WMs(isnan(CT))=1; % return to nan the land
    %% plot section data
    for sp=1:numel(varplot)
        count=count+1;
        if numel(varplot)==1
            if f==1;    ax1=subplot(3,1,f); cbPOS = [0.8911     0.7658    0.0132    0.1558]; MAXdist=3.5;
            elseif f==2 ax2 = subplot(3,1,f);  cbPOS = [0.8911    0.4654    0.0132    0.1558];MAXdist=3.7;
            elseif f==3 ax3 = subplot(3,1,f);  cbPOS = [0.8911    0.1691    0.0132    0.1558];MAXdist=2.2; end
        elseif numel(varplot)==2
            set(fg, 'Position', [26 396 693 371])
            if f==1;
                MAXdist=3.7;
                if sp==1; ax1=subplot(2,3,1);  title (fjords{f}); end
                if sp==2; ax2=subplot(2,3,4);  end
            elseif f==2
                MAXdist=3.2;
                if sp==1; ax3 = subplot(2,3,2); title (fjords{f});end
                if sp==2; ax4= subplot(2,3,5); end
            elseif f==3
                MAXdist=2.2;
                if sp==1; ax5 = subplot(2,3,3); title (fjords{f});
                    cbPOS = [0.9214    0.5741    0.0151    0.3989]; end
                if sp==2; ax6 = subplot(2,3,6);  cbPOS = [0.9214    0.1186    0.0151    0.3989]; end
            end
        elseif numel(varplot)==3
            set(fg, 'Position', [25 236 738 531])

            if f==1;
                MAXdist=3.7;
                if sp==1; ax1=subplot(3,3,1);  title (fjords{f}); end
                if sp==2; ax2=subplot(3,3,4);  end
                if sp==3; ax3=subplot(3,3,7);  end
            elseif f==2
                MAXdist=3.2;
                if sp==1; ax4 = subplot(3,3,2); title (fjords{f});end
                if sp==2; ax5= subplot(3,3,5); end
                if sp==3; ax6=subplot(3,3,8);  end
            elseif f==3
                MAXdist=2.2;
                if sp==1; ax7 = subplot(3,3,3); title (fjords{f});
                    cbPOS = [0.9144    0.6897    0.0094    0.2550]; end
                if sp==2; ax8 = subplot(3,3,6);  cbPOS = [0.9144   0.3789    0.0094    0.2550]; end
                if sp==3; ax9 = subplot(3,3,9);  cbPOS = [0.9144    0.07    0.0094    0.2550]; end
            end

        end
        % plot variable
       if strcmp(varplot{sp},'WM')
            % water mass plot
            CMAP = [...
                1.0 1.0 1.0;  % 1 WHITE UNDEFINED
                1.0 0.2 0.2; % 2 RED AWm
                0.1 0.3 0.2; %  DARKGREEN AWc
                0.2 0.4 1.0; % 3 BLUE PWc
                0.2 0.8 0.4; % 4 LIGHTGREEN PW
                1.0 0.6 0.1; % 6 ORANGE PWw
                ];
            nvar=WMs;
            clabelstr = 'water mass class';
            CLIM=[1 6];
        elseif strcmp(varplot{sp},'CT')
            nvar=CT;
            meanval = ceil(max(max(abs(nvar))));
            CMAP = jet(256);
            CLIM = [-1 1].*meanval;
            CLIM=[-1.5 1.5];
            clabelstr = 'CT (\circC)';
        elseif strcmp(varplot{sp},'SA')
            nvar=SA;
            CLIM = [min(min(nvar)) max(max(nvar)) ];
            CLIM = [27 34];
            CMAP = jet(256);
            clabelstr = 'SA (g kg^{-1})';
        end
        levels = linspace(min(nvar(:)), max(nvar(:)), 40);
        secxvar=distance; xlabstr = 'Distance along terminus (km)';
        secyvar=depth;    ylabstr = 'Depth (m)';
        stnlocx = [stationL];
        stnlocy = zeros(size(stnlocx));
        % define limits for figure
        YLIM = [-10 max(secyvar(:))+5];
        XLIM = [0 MAXdist];
        % plot variable
        if strcmp(varplot{sp},'WM')
            pcb = imagesc(secxvar,secyvar, nvar); % need to colour each individually
        else
            pcb = contourf(secxvar,secyvar, nvar,levels,'LineStyle','none'); % contouring is better for other variables
        end
        hold on
        % add countour lines RHO
        [c, h]=contour(secxvar,secyvar,RHO,[23.9 25 26 26.8],'-',...
            'EdgeColor',[0.6 0.6 0.6],'LabelColor',[0.6 0.6 0.6]);
        clabel(c,h)
        % add triangles at the stations. filled the triangle at the plume station
        plot(stnlocx,stnlocy,'vk','markerfacecolor',[0.7 0.7 0.7],'markersize',7)
        scatter(mssdistance,depthEmax,35,'o','MarkerEdgeColor', 'm','MarkerFaceColor','none')
        scatter(mssdistance,depthEmax,normE*10,'.','MarkerEdgeColor', 'm','MarkerFaceColor','none')
        % draw mss plume station in blue
        type='Plume';
        [STNp]=select_stations(fjords{f},type); % mss plume station
        % add the ctd plume stations
        % plume stations
        % ctd plume station number (pstn) and MSS plume station index (GFidx) to mark them on subplots.
        if strcmp(fjords{f},'Flado');      pstn = 39; GFidx = [4]; end
        if strcmp(fjords{f},'3Miippugut'); pstn = [8,5];  GFidx = [2]; end % ctd plume was the one in the picture I should made this blue in the map
        if strcmp(fjords{f},'Kivioq');     pstn = [18,20];  GFidx = [4,5]; end
        % in case of 3-miippugut, the stationNo in the merged nc file
        % is re-ordered from left to right along the glaicer front
        % stations total 7, so I must flip the STNp
        if strcmp(fjords(f),'3Miippugut'); STNp=7-STNp+1; end

        STNp=[STNp pstn];
        clear plumeidx
        msscount=0; 
        if ~isempty(STNp)
            for ii=1:length(STNp)
                n= find(strcmp(stationNo,['mss',num2str(STNp(ii))]));
                nn= find(strcmp(stationNo,['ctd',num2str(STNp(ii))]));
                if ~isempty(n)
                    msscount=msscount+1; 
                    plumeidx(ii) = n;
                    plumidxMSS(msscount) = n; 
                end
                if ~isempty(nn)
                    plumeidx(ii) = nn;
                end
            end
            plot(stnlocx(plumeidx),stnlocy(1),'vb','markerfacecolor','b','markersize',7)
        end
      
        %% finlize graph
        grid on
        set(gca, 'YDir', 'reverse');
        caxis(CLIM) % set the contour colour limits because when we add density countours the automatic plot may shift colours to include density values
        % set the x axis
        xlim(XLIM);
        ylim(YLIM);
        % strings
        if numel(varplot)==2
            if sp==2; xlabel(xlabstr); end
            if f==1;  ylabel(ylabstr); end
            if sp==1; title(glaciername{f}); end
            if f==3;
                cb=colorbar;cb.Position = cbPOS;
                cb.Label.String = clabelstr;  % add label text
            end  
        elseif numel(varplot)==3
            ylim([-10 210]);
            if sp==3; xlabel(xlabstr); end
            if sp==1; title(glaciername{f}); end
            if f==1;  ylabel(ylabstr); end
            if f==3
                cb=colorbar;cb.Position = cbPOS;
                cb.Label.String = clabelstr;
                if sp==3;
                    cb.Ticks      = [1.3   2.3   3.2  4.0   4.7    5.5  ];
                    cb.TickLabels = {'nan','MAWw','MAWc','PWc','PW','PWw'};
                end
               
            end

        else % put labels on all subplots
            xlabel(xlabstr);
            ylabel(ylabstr);
            cb=colorbar;cb.Position = cbPOS;
            cb.Label.String = clabelstr;  % add label text
            eval(['ax',num2str(count),'.Colormap=CMAP;']);
            title(glaciername{f});
        end
            ax_current=gca;
            ax_current.Colormap = CMAP;
        % add letter to the plot
        text (letterpos(f,1),letterpos(f,2),letterplot{count},'FontSize',FZ)
    end


    %%
end
% save the figure
if numel(varplot)==2
    figname = ['section_terminus_merge_',varplot{1},varplot{2},'.png'];
    % resize the subplots to maximize the space
    ax1.Position =[0.0563    0.5660    0.2641    0.4124];
    ax2.Position =[0.0563    0.1100    0.2641    0.4124];
    ax3.Position =[0.3535    0.5660    0.2641    0.4124];
    ax4.Position =[0.3535    0.1100    0.2641    0.4124];
    ax5.Position =[0.6522    0.5660    0.2641    0.4124];
    ax6.Position =[0.6522    0.1100    0.2641    0.4124];
elseif numel(varplot)==3
    figname = ['fig3_section_terminus_merge_',varplot{1},varplot{2},varplot{3},'.png'];
    % resize the subplots to maximize the space
    ax1.Position =[0.0637    0.6866    0.2518    0.2577];
    ax2.Position =[0.0637    0.3780    0.2518    0.2577];
    ax3.Position =[0.0637    0.0708    0.2518    0.2577];
    ax4.Position =[0.3548    0.6866    0.2518    0.2577];
    ax5.Position =[0.3548    0.3780    0.2518    0.2577];
    ax6.Position =[0.3548    0.0708    0.2518    0.2577];
    ax7.Position =[0.6500    0.6866    0.2518    0.2577];
    ax8.Position =[0.6500    0.3780    0.2518    0.2577];
    ax9.Position =[0.6500    0.0708    0.2518    0.2577];
else
    figname = ['fig3_section_terminus_merge_',varplot{1},'.png'];
    % do nothing
end
if savefig==1; exportgraphics(gcf, [figPp,figname], 'Resolution', RL); end
