function [ F1z, F1F0 , plothandle, plotdata ] = get_phase_modulation_index( psth, psth_duration, TF, boolplot )
% compute F1z and F1/F0 modulation indices given a post-stimulus time histogram (PSTH).
%   psth: post-stimulus time histogram
%   psth_duration: duration of the PSTH
%   TF: Target frequency for analysis
%   boolplot: boolean flag to control plotting
%   F1z: F1z modulation index
%   F1F0: F1/F0 modulation index
%   plothandle: handle to the plot (if boolplot is true)
%   plotdata: struct containing data for plotting
% --------------------------------
% Giulio Matteucci 2021

% preprocess input
interpfactor = 2;
n = length(psth);
x = linspace(0, psth_duration, n);
xq = linspace(0, psth_duration, n * interpfactor);
psth = interp1(x, psth, xq, 'pchip');
N = length(psth);
N_f = 3 * N;

% compute F1z
ds = psth - mean(psth);
T_s = psth_duration / N;  
[pow, f] = compute_pBT(ds, fix(N / 3), 3 * N, 1 / (psth_duration / N), 't');
fidx = find(f <= TF, 1, 'last');
meanspect = mean(pow);
sigspect = std(pow);
F1z = (pow(fidx) - meanspect) / sigspect;

% compute F1/F0
[pow_bis, ~] = compute_pBT(ds, fix(N / 3), 3 * N, 1 / (psth_duration / N), 't');
F1F0 = pow_bis(fidx) / pow_bis(1);

% store data for plotting
plotdata = struct('N_f', 3 * N, 'f', f, 'fidx', fidx, 'pow', pow, 'meanspect', mean(pow), 'sigspect', std(pow), 'TF', TF, 'F1F0', F1F0, 'F1z', F1z);

if boolplot
    % plot psth and spectrum
    plothandle=figure('units','normalized','outerposition',[0 0 1 1]);
    subplot(1,2,1);
    psth_x=0:T_s:(length(psth)-1)*T_s;
    plot(psth_x,psth,'k','LineWidth',3)
    hlbx=get(gca,'Xlabel');
    set(hlbx,'String','time (s)','FontWeight','bold','FontSize',12,'color','k')
    hlby=get(gca,'Ylabel');
    set(hlby,'String','unit activity','FontWeight','bold','FontSize',12,'color','k')
    title('Unit response over time');
    axis square
    set(gca,'fontsize',12);
    subplot(1,2,2);
    plot(f(1:round(N_f/2)+1),pow(1:round(N_f/2)+1),'k','LineWidth',3);
    hold on
    plot(f(fidx),pow(fidx),'ob','LineWidth',6);
    plot(f(1:round(N_f/2)+1),(meanspect+sigspect)*ones(size(pow(1:round(N_f/2)+1))),'--b','LineWidth',1);
    plot(f(1:round(N_f/2)+1),(meanspect-sigspect)*ones(size(pow(1:round(N_f/2)+1))),'--b','LineWidth',1);
    plot(f(1:round(N_f/2)+1),(meanspect)*ones(size(pow(1:round(N_f/2)+1))),'.-b','LineWidth',0.5);
    ylimit=get(gca,'ylim');
    xlimit=get(gca,'xlim');
    ttt=text(0.6*xlimit(2),0.85*ylimit(2),['target TF = ',num2str(TF),' Hz'],'FontSize',12); %#ok<NASGU>
    set(gca,'FontSize',12);
    hlabelx=get(gca,'Xlabel');
    set(hlabelx,'String','f (Hz)','FontWeight','bold','FontSize',12,'color','k')
    hlabely=get(gca,'Ylabel');
    set(hlabely,'String','PSD','FontWeight','bold','FontSize',12,'color','k')
    title(['Power spectrum (F1z = ',num2str(F1z),', F1F0 = ',num2str(F1F0),')']);
    hold off
    axis square
    set(gca,'fontsize',12);
else
    % do not plot
    plothandle=[];
end

end
