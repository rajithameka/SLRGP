function [Mn,cv] = gpmean(xtr,xte,yt,h,covfunc)
vr = exp(2*h.lik);
kxx = feval(covfunc{:}, h.cov, xtr, xtr);
knx = feval(covfunc{:}, h.cov, xte, xtr);
knn = feval(covfunc{:}, h.cov, xte, xte);
kxn = knx';
I = eye(size(kxx));
I = (vr)*I;
V = kxx+I;
try
    L = chol(V,'lower');
catch
    try
        [Ve,D] = eig(V);      
        d= diag(D);           
        d(d <= 1e-7) = 1e-2;   
        D_c = diag(d);        
        A_PD = Ve*D_c*Ve'; 
        L = chol(A_PD,'lower');
        disp('Pos1')
    catch
        n = length(kxx);
        try
            addvar = 1e-10*abs(min(min(kxx)));
            Vn = V+eye(n)*addvar;
            L = chol(Vn,'lower');
            disp('Pos2')
        catch
            addvar = 1e-5*abs(min(min(kxx)));
            V = V+eye(n)*addvar;
            L = chol(V,'lower');
            disp('Pos3')
        end
    end
end

Z = (L\kxn);
if isnan(yt) == 1
    Mn = nan;
else
    alpha = L'\(L\yt);
    Mn = (knx)*(alpha);
end
cv = knn - (Z'*Z);
cv = diag(cv);
cv = max(cv,0);
cv = cv+vr;
