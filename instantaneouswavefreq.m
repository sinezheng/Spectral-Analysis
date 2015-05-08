
function varargout = instantaneouswavefreq(Wxy,freq)
% [mean_instantaneous_freq,peakpower_instantaneous_frequency] =
% instantaneouswavefreq(Wxy,freq)

if nargin < 2
    errordlg('At least 2 input variables required')
    return
end

if isreal(Wxy)
%     errordlg('First input variable must be a matrix of complex wavelet coefficients!')
%     return
elseif numel(freq)==1
    errordlg('2nd input variable must be a vector!')
    return
elseif (size(freq,1)>1 && size(freq,2)>1)
    errordlg('2nd input variable must be a vector!')
    return
end


freq = flipud(sort(freq(:))); % Ensures that 'freq' is a col vec with values in descending order

fmat  = repmat(freq,1,size(Wxy,2)); % Matrix where each col is the 
        % freq vector and # of cols = length(time)
Wxy_abs = abs(Wxy);
fmat(Wxy_abs==0)=0;
tvpow =sum(Wxy_abs); % Vector of length = length(time), where each 
           % entry is the total power at all frequencies at each time point
Wxy_tvpow = repmat(tvpow,size(Wxy,1),1);
Wxy_tvpow_prob = Wxy_abs./Wxy_tvpow;

mfvec = sum(fmat.*Wxy_tvpow_prob);
mfvec(isnan(mfvec))=0;

maxmat = max(Wxy_abs);
maxmat = repmat(maxmat,size(Wxy,1),1);
diffmat = Wxy_abs-maxmat;
diffmat(diffmat==0)=1;
diffmat(diffmat>1)=0;
diffmat(diffmat<0)=0;
pfvec = sum(diffmat.*fmat);
pfvec(isnan(pfvec))=0;

varargout{1} = mfvec;
varargout{2} = pfvec;
