function LMind = LG(xtr,xvl,ytr,h,covfunc,candL)
tempX_validset = xvl;
tempX_trainset = xtr;
tempy_trainset = ytr;
gb = get_gamma(xtr,ytr,h,xvl,covfunc,candL);
% gb = 1e-3;
% [yte_pred, ~] = gp(h, @infGaussLik, meanfunc, covfunc, likfunc, xtr,ytr, xvl);
[yte_pred,yc] = gpmean(xtr,xvl,ytr,h,covfunc);
tempyc = yc;
%%
% fsummms = LGP(xtr,xvl,ytr,h,gb,covfunc,yte_pred);
% % [~,fsum] = gpmean(xtr,xvl,nan,h,covfunc);
% % fsum = diag(ycov);
% ME = 1/2*log(fsummms)+1/2*(log(2*pi)+1);
% [~,ind] = max(ME);
% LMind = ind;
%%
tempy = yte_pred;
sxv = size(xvl,1);
MSEmm = zeros(sxv,1);
for pnt = 1:sxv
    xa  = xvl(pnt,:);
    xvl(pnt,:) = [];    
    xtr = vertcat(xtr, xa);
    ya  = yte_pred(pnt,:);
    yte_pred(pnt,:) = [];    
    ytr = vertcat(ytr, ya);
    fsummms = LGP(xtr,xvl,ytr,h,gb,covfunc,yte_pred);
    yc(pnt,:) = [];  
    al = mean(yc - fsummms);
    MSEmm(pnt,:) = al;
%     fsummms = diag(ycov);
%     mmse = max(fsummms);
%     MSEmm(pnt,:) = mmse;
    xvl = tempX_validset;
    xtr = tempX_trainset;
    yte_pred = tempy;
    ytr = tempy_trainset;
    yc = tempyc;
end
[~,ind] = max(MSEmm);
LMind = ind;
