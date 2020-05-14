function [xnew,ynew,xvnew,yvnew,hypnew,Meansq,Meanvar,f2] = get_updatesSLRGP(X_train,y_train,X_valid,y_valid,hyp1,covfunc,meanfunc,likfunc,X_test,y_test,candL,hypit)

ind = LG(X_train,X_valid,y_train,hyp1,covfunc,candL);

X_add = X_valid(ind,:);
y_add = y_valid(ind,:);


X_valid(ind,:) = [];
y_valid(ind,:) = [];

X_train = vertcat(X_train, X_add);
y_train = vertcat(y_train, y_add);
hypnew = minimize(hyp1, @gp, hypit, @infGaussLik, meanfunc, covfunc, likfunc, X_train,y_train);
[y_new,ycov] = gpmean(X_train,X_test,y_train,hypnew,covfunc);
Meansq = MSE(y_test,y_new);
Meanvar = mean(ycov);
xnew = X_train;
ynew = y_train;
xvnew = X_valid;
yvnew = y_valid;
   

int = 8;
if size(X_train,2) == 2
    f2 = figure(1);
    sz=10;
    set(gcf,'Position',[100 100 500 500])
    set(gcf,'Color',[1 1 1])
    contour(reshape(X_test(:,1),50,50),reshape(X_test(:,2),...
        50,50),reshape(y_new,50,50),100);
    hold on;
    s1 = plot(X_train(1:int,1),X_train(1:int,2),'mo','MarkerEdgeColor','k',...
        'MarkerFaceColor',[.49 1 .63],...
        'MarkerSize',5)
    hold on;
    s2 = plot(X_train(int+1:end,1),X_train(int+1:end,2),'r*')
    hold off;
    xlabel('$x_1$','FontSize',sz,'Interpreter','Latex');
    ylabel('$x_2$','FontSize',sz,'Interpreter','Latex'); 
    clbr = colorbar('southoutside');
    clbr.TickLabelInterpreter='Latex';
    clbr.FontSize=sz;
    caxis([-20 300]);
    ylabel(clbr,'Response','FontSize',sz,'Interpreter','Latex')
    title('Predicted Function Contour','FontSize',sz,'Interpreter','Latex')
    lgd = legend([s1,s2],{'Initial Evaluated Points','Additional Evaluated Points'});
    lgd.Interpreter = 'latex';
    lgd.FontSize = sz-2;
    lgd.Position=[0.52 0.9 0 0];
    yclr2 = [0 0 0];
    lgd.EdgeColor=yclr2;
    lgd.Orientation='horizontal';
    set(gca,'TickLabelInterpreter','Latex','FontSize',sz);

end

   





