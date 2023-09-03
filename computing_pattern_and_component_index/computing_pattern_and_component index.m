% add DSI!!!
close all
clear all
clc

% -------------------------------------------------------------------------
% README: this test function creates a dummy psth with a periodic 
% "component selectivity": response to plaid is the linear superposition of th 
% responses to two components presented separately.
% "pattern selectivity": response to plaid is the linear superposition of th 
% responses to two components presented separately.
% -------------------------------------------------------------------------

% generate synthetic tuning curves ----------------------------------------

% generate compute pattern and component index ----------------------------
[pattern_index, z_pattern, z_component, r_pattern, r_component, cds_pred, pds_pred] = ...
    get_pattern_index(tuning_curve_grating, tuning_curve_plaid, plaid_half_angle, angle_step_orig)

% generate synthetic psth -------------------------------------------------

% figure; plot(x_new,CDS_prediction./max(Resp_Plaid),'--','color','k');
% hold on; plot(x_new,PDS_prediction./max(Resp_Plaid),'-','color','k');

pp = plot_shaded_auc(ax, distr_x, distr_y, alpha, color)

% plot(x_new,Resp_Plaid./max(Resp_Plaid),'color',[1,0.25,0],'linewidth',2)
% ylimused=get(gca,'ylim');
% text(15,0.95*ylimused(2),['rc=',num2str(round(rc,2))])
% text(15,0.9*ylimused(2),['rp=',num2str(round(rp,2))])
% text(15,0.85*ylimusteaed(2),['rpc=',num2str(round(rcp,2))])
% title(['Zp and Zc computation diagnostics ( Zp = '...
%     ,num2str(round(Zp,2)),' Zc = ',num2str(round(Zc,2)),' )'])
% legend({'c pred','p pred','p resp'})
% xlabel('direction')
% xlabel('amplitude')