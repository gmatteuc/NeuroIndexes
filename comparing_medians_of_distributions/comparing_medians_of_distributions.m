% generate synthetic data
input_distr{1}=randn(1,100);
input_distr{2}=1.2*randn(1,100)+2;
input_distr{3}=3*randn(1,100)-2;
% generate synthetic data labels
input_labels{1}='distribution 1';
input_labels{2}='distribution 2';
input_labels{3}='distribution 3';
% generate synthetic data colors
input_colors{1}=[0.5,0.5,1];
input_colors{2}=[0,0,0.65];
input_colors{3}=[0,0,0.35];
% get range of values to plot
yrange=[min(cell2mat(input_distr))-diff(yrange).*0.2,...
    max(cell2mat(input_distr))+diff(yrange).*0.2];
% initialize the figure
plothandle1=figure('units','normalized','outerposition',[0 0 1 1]);
input_ax=subplot(2,3,[1,2,4,5]);
% set settings grafic parameters for violin distribution plotting ------
inputpars.boxplotwidth=0.4;
inputpars.boxplotlinewidth=2;
inputpars.densityplotwidth=0.4;
inputpars.scatterjitter=inputpars.boxplotlinewidth*0.1;
inputpars.scatteralpha=0.33;
inputpars.scattersize=40;
inputpars.distralpha=0.5;
inputpars.boolscatteron=1;
% set settings content parameters for violin distribution plotting ------
inputpars.yimtouse=yrange;
inputpars.ks_bandwidth=diff(yrange).*0.1;
inputpars.xlabelstring=[];
inputpars.ylabelstring='feature value';
inputpars.inputaxh=input_ax;
inputpars.titlestring='example violin plot comparing 3 distributions';
inputadata.inputdistrs=input_distr;
inputpars.xtickslabelvector=input_labels;
inputpars.distrcolors=input_colors;
inputpars.n_distribs=numel(inputadata.inputdistrs);
inputpars.dirstrcenters=(1:inputpars.n_distribs);
inputpars.xlimtouse=[-0,inputpars.n_distribs+1];
% draw violin plot
inputaxh = plot_violinplot(inputadata,inputpars);
hold on;
plot(inputaxh,inputpars.xlimtouse,[0,0],'--','linewidth',2,'color',[0.5,0.5,0.5])
% get matrix of median difference surprises
surp_meddiff=NaN(numel(input_distr),numel(input_distr));
for distrfirst_idx=1:numel(input_distr)
    for distrsecond_idx=1:numel(input_distr)
        % get data from current pair of areas
        curr_y1=squeeze(inputadata.inputdistrs{distrfirst_idx});
        curr_y1(isnan(curr_y1))=[];
        curr_y2=squeeze(inputadata.inputdistrs{distrsecond_idx});
        curr_y2(isnan(curr_y2))=[];
        % perform median difference test
        [curr_p_val_wilko,curr_h_val_wilko]=ranksum(curr_y1',curr_y2');
        % get surprise
        surp_meddiff(distrfirst_idx,distrsecond_idx)=-log10(curr_p_val_wilko);
    end
end
% reorder surprise matrix
inputmat=surp_meddiff;
inputlab=inputpars.xtickslabelvector;
clustmetric='cosine';
clustmethod='average';
[reordered_matrix,reordered_labels,reordering_permutation,tree] = ...
    reorder_compmat(inputmat,inputlab,clustmethod,clustmetric);
% get current subplot axe
currax=subplot(2,3,3);
hold(currax,'on');
% draw surprise matrix
imagesc(currax,flipud(reordered_matrix)); colormap(gray); colorbar;
yticks(currax,1:size(reordered_matrix,1))
xticks(currax,1:size(reordered_matrix,1))
yticklabels(currax,reordered_labels(size(reordered_matrix,1):-1:1))
xticklabels(currax,reordered_labels(1:size(reordered_matrix,1)))
xlim(currax,[(1-0.5),(size(reordered_matrix,1)+0.5)])
ylim(currax,[(1-0.5),(size(reordered_matrix,1)+0.5)])
% draw significance asterisks
for distrfirst_idx=1:numel(input_distr)
    for distrsecond_idx=1:numel(input_distr)
        if reordered_matrix(distrsecond_idx,distrfirst_idx)>=-log10(0.05)
            scatter(currax,distrfirst_idx,((numel(input_distr)+1)-distrsecond_idx),100,'*',...
                'markerfacecolor',[0.4,0.4,1],'markeredgecolor',[0.4,0.4,1]);
        end
    end
end
title(currax,'distribution median comparison surprise');
set(currax,'fontsize',12)
% get current subplot axe
currax=subplot(2,3,6);
% draw dendrogram
dd=dendrogram(tree,'Reorder',reordering_permutation);
for i=1:numel(dd)
    dd(i).Color = [0 0 0];
    dd(i).LineWidth = 2;
end
xticklabels(reordered_labels)
xtickangle(45)
title(currax,'hierarchical clustering dendrogram');
ylabel('distance')
set(currax,'fontsize',12)
sgtitle('comparing medians of distributions')

