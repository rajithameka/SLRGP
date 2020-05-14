clc; clear;
rng(200,'twister')
%% User Inputs - Changed Every run
D = 2; %Dimension of the function
Eval_func = 'Branin';
in_tr = 8; % Number of initial evaluated points
noise_level = 1; % percentage of mean response of func added as noise
%%
q = 40; % Number of additional points to evaluate
candL = [0.00001,0.0001,0.001,0.01,0.1,1,10,100,1000]; % lambda candidate set
[lb,ub] = func_bounds(Eval_func,D); % bounds of function to be tested
c = add_noise(D,lb,ub,noise_level,Eval_func); % amount of noise added based on noise_level


ntr = 100;
nte = 1000;
hypit = -1000;
nh = 10;
nit = 20000;
total_episodes = 1;        % Total episodes

reqitrseed = 1;

lv = 100;
%% GPML Mean, Cov ang Lik functions
meanfunc = [];                  
covfunc = {'covSEiso'}; 
% covfunc = {'covPERard',{@covMaternard ,3}};            
likfunc = @likGauss; 


if D == 1
    X_test = (linspace(lb(1),ub(1),nte))'; 
    y_test = func_eval(Eval_func,X_test);
    figure;
    plot(X_test,y_test,'g');
end
if D == 2
    x1 = linspace(lb(1),ub(1),50); x2 = linspace(lb(2),ub(2),50);
    X_test = apxGrid('expand',{x1',x2'});
    y_test = func_eval(Eval_func,X_test);
end
if D >= 3
    xtrd = lhsdesign(nte,D);
    X_test = bsxfun(@plus,lb,bsxfun(@times,xtrd,(ub-lb)));
    yte = func_eval(Eval_func,X_test);

end

if D == 2
    fg = figure(2);
    clf;sz = 10;
    set(gcf,'Position',[100 100 500 500])
    set(gcf,'Color',[1 1 1])
    h = contour(reshape(X_test(:,1),length(x1),length(x1)),reshape(X_test(:,2),...
        length(x1),length(x1)),reshape(y_test, length(x1), length(x1) ),lv);
    xlabel('$x_1$','FontSize',sz,'Interpreter','Latex');
    ylabel('$x_2$','FontSize',sz,'Interpreter','Latex'); 
    clbr = colorbar('southoutside');
    clbr.TickLabelInterpreter='Latex';
    clbr.FontSize=sz;
    caxis([-20 300]);
    ylabel(clbr,'Response','FontSize',sz,'Interpreter','Latex')
    title('Actual Function Contour','FontSize',sz,'Interpreter','Latex')
    set(gca,'TickLabelInterpreter','Latex','FontSize',sz);
end
figname1 = 'Branin_True_Contour';

print(fg,figname1,'-dpng','-r400');
%% SLRGP
Lres = zeros(q+1,total_episodes);
filename = 'SLRGPBranintest.gif';


fig_1 = figure(1);
clf;
sz=20;
lsz='linesize';lssz=1.1;
msz='MarkerSize';mssz=10;
set(gcf,'Position',[100 100 800 800])
set(gcf,'Color',[1 1 1])

for episode = 1:total_episodes
    res = zeros(q+1,1);
    [X_trainset,y_trainset,X_validset,y_validset,hyp] = gen_data2(reqitrseed,episode,ntr,D,in_tr,c,Eval_func,lb,ub,covfunc);

    % Hyper parameter optimization function
    hyp2_1 = minimize(hyp, @gp, hypit, @infGaussLik, meanfunc, covfunc, likfunc, X_trainset,y_trainset);
    hyp2 = minimize(hyp2_1, @gp, hypit, @infGaussLik, meanfunc, covfunc, likfunc, X_trainset,y_trainset);

    %Initial MSE
    [y_new, ~] = gp(hyp2, @infGaussLik, meanfunc, covfunc, likfunc, X_trainset,y_trainset, X_test);
    res(1,1) = MSE(y_test,y_new);
 
    hyp1 = hyp2;
    X_valid = X_validset;
    y_valid = y_validset;
    X_train = X_trainset;
    y_train = y_trainset;
        

    for step = 1:q
        [X_train,y_train,X_valid,y_valid,hyp1,Meansq,Meanvar,fig_1] = get_updatesSLRGP(X_train,y_train,X_valid,y_valid,hyp1,covfunc,meanfunc,likfunc,X_test,y_test,candL,hypit);
        res(step+1,1) = Meansq;
        
        % Capture the plot as an image 
        frame = getframe(fig_1); 
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 
        % Write to the GIF File 
        if step == 1 
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
        else 
          imwrite(imind,cm,filename,'gif','WriteMode','append'); 
        end 
    end 
    Lres(:,episode) = res;

end


