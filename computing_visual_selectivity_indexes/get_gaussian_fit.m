function [fitParamsCell, fitGaussianCell, fitOptCostCell] = get_gaussian_fit(data, regpars, bslbool, useparallelbool)
% [fitParamsCell, fitGaussianCell, fitOptCostCell] = get_gaussian_fit(data, regpars, bslbool, useparallelbool)
%  fits Gaussian functions to columns of data
%   data: 2D array where each column is a different curve
%   regpars: regularization parameters for the objective function
%   bslbool: boolean to indicate if a baseline should be included in the Gaussian fit
%   use_parallel: boolean to indicate if parallel processing should be used
%   fitParamsCell: cell array of best-fit parameters for each column
%   fitGaussianCell: cell array of function handles to the fitted Gaussians
%   fitOptCostCell: cell array of best-fit cost function values
% --------------------------------
% Giulio Matteucci 2021

% Define Gaussian function based on bslbool
if bslbool == 0
    gaussian = @(params, x) params(1) * exp(-(x - params(2)).^2 / (2 * params(3)^2));
else
    gaussian = @(params, x) (params(1) * exp(-(x - params(2)).^2 / (2 * params(3)^2))) + params(4);
end

% Get the number of columns in the input data
[~, M] = size(data);

% Initialize cell arrays for fit parameters and fitted Gaussian function handles
fitParamsCell = cell(1, M);
fitGaussianCell = cell(1, M);
fitOptCostCell = cell(1, M);

if useparallelbool

    parfor i = 1:M % parallel version -------------------------------------

        % extract the current curve (i.e. column)
        dataColumn = data(:, i);
        dataColumnX = (1:length(dataColumn))';

        if bslbool==0
            % find the initial guess for the parameters
            [amp_guess, idx] = max(dataColumn);
            mu_guess = idx;
            sigma_guess = std(dataColumn);
            % store initial parameters
            initialParams = [amp_guess, mu_guess, sigma_guess];
        else
            % find the initial guess for the parameters
            bsl_guess=nanmedian(dataColumn); %#ok<NANMEDIAN>
            dataColumn_bsl_subtr=dataColumn-bsl_guess;
            [amp_guess, idx] = max(dataColumn_bsl_subtr);
            mu_guess = idx;
            sigma_guess = std(dataColumn_bsl_subtr);
            % store initial parameters
            initialParams = [amp_guess, mu_guess, sigma_guess, bsl_guess];
        end
        initialParams=initialParams+eps.*randn(size(initialParams));

        % define the objective function to minimize for least squares fitting
        local_gaussian=gaussian;
        if bslbool==0
            objFun_gen = @(params, lambda) ...
                ( sum((local_gaussian(params,dataColumnX) - dataColumn).^2) + ...
                lambda(3).*(1/params(3)) + ...
                lambda(1).*(params(1)) + ...
                lambda(2).*(params(2)) );
        else
            objFun_gen = @(params, lambda) ...
                ( sum((local_gaussian(params,dataColumnX) - dataColumn).^2) + ...
                lambda(3).*(1/params(3)) + ...
                lambda(1).*(params(1)) + ...
                lambda(2).*(params(2)) + ...
                lambda(4).*(params(4)) );
        end
        objFun =  @(params) objFun_gen(params, regpars);

        % perform the nonlinear least squares fitting by minimizing the objective function
        options = optimoptions('fminunc', 'Algorithm', 'quasi-newton', 'Display', 'off');
        fitParams = fminunc(objFun, initialParams, options);

        % store best fit parameters
        fitParamsCell{i} = fitParams;
        % create and store handle to the fitted Gaussian function
        fitGaussianCell{i} = @(x) local_gaussian(fitParams, x);
        % store best fit cost function value
        fitOptCostCell{i}=objFun_gen(fitParams,zeros(size(regpars)));

    end
else
    for i = 1:M % serial version -------------------------------------------------

        % extract the current curve (i.e. column)
        dataColumn = data(:, i);
        dataColumnX = (1:length(dataColumn))';
        if bslbool==0
            % find the initial guess for the parameters
            [amp_guess, idx] = max(dataColumn);
            mu_guess = idx;
            sigma_guess = std(dataColumn);
            % store initial parameters
            initialParams = [amp_guess, mu_guess, sigma_guess];
        else
            % find the initial guess for the parameters
            bsl_guess=nanmedian(dataColumn); %#ok<NANMEDIAN>
            dataColumn_bsl_subtr=dataColumn-bsl_guess;
            [amp_guess, idx] = max(dataColumn_bsl_subtr);
            mu_guess = idx;
            sigma_guess = std(dataColumn_bsl_subtr);
            % store initial parameters
            initialParams = [amp_guess, mu_guess, sigma_guess, bsl_guess];
        end
        initialParams=initialParams+eps.*randn(size(initialParams));
        % define the objective function to minimize for least squares fitting
        if bslbool==0
            objFun_gen = @(params, lambda) ...
                ( sum((gaussian(params,dataColumnX) - dataColumn).^2) + ...
                lambda(3).*(1/params(3)) + ...
                lambda(1).*(params(1)) + ...
                lambda(2).*(params(2)) );
        else
            objFun_gen = @(params, lambda) ...
                ( sum((gaussian(params,dataColumnX) - dataColumn).^2) + ...
                lambda(3).*(1/params(3)) + ...
                lambda(1).*(params(1)) + ...
                lambda(2).*(params(2)) + ...
                lambda(4).*(params(4)) );
        end
        objFun =  @(params) objFun_gen(params, regpars);
        % perform the nonlinear least squares fitting by minimizing the objective function
        options = optimoptions('fminunc', 'Algorithm', 'quasi-newton', 'Display', 'off');
        fitParams = fminunc(objFun, initialParams, options);
        % store best fit parameters
        fitParamsCell{i} = fitParams;
        % create and store handle to the fitted Gaussian function
        fitGaussianCell{i} = @(x) gaussian(fitParams, x);
        % store best fit cost function value
        fitOptCostCell{i}=objFun_gen(fitParams,zeros(size(regpars)));

    end

end

end