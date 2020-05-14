function gamma = get_gamma(xtr,yt,hyp,xvl,covfunc,candL)
lmdaset = [];
gtemp = [];
opxtr = xtr;
opxvl = xvl;

for g = 1:length(candL)
    gbl = candL(g);
    [yte_pred,yc] = gpmean(opxtr,opxvl,yt,hyp,covfunc);
    fsum = LGP(opxtr,opxvl,yt,hyp,gbl,covfunc,yte_pred);
    [~,ind] = max(fsum);
    if gbl == candL(1)
        X_add = opxvl(ind,:);
        opxvl(ind,:) = [];
        opxtr = vertcat(opxtr, X_add);
        [~,fsum] = gpmean(opxtr,opxvl,nan,hyp,covfunc);
        yc(ind,:) = [];  
        al = mean(yc - fsum);
        lmdaset = [al];
        gtemp = [g];
    else
        xaddtemp = X_add;
        X_add = opxvl(ind,:);
        if isequal(xaddtemp,X_add)==1
            disp('Do Nothing')
        else
            opxvl(ind,:) = [];
            opxtr = vertcat(opxtr, X_add);
            [~,fsum] = gpmean(opxtr,opxvl,nan,hyp,covfunc);
            yc(ind,:) = [];  
            al = mean(yc - fsum);
            lmdaset = [lmdaset,al];
            gtemp = [gtemp,g];
        end
    end
    opxtr = xtr;
    opxvl = xvl;
end
[~,ind] = max(lmdaset);
gamma = gtemp(ind);
    

        
        
       
       
    
    



