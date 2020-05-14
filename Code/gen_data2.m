function [X_trainset,y_trainset,X_validset,y_validset,hyp] = gen_data2(reqitrseed,i,ntr,dim,in_tr,c,Eval_func,lb,ub,covfunc)
rng(reqitrseed(i),'twister')
% Train Set
xtrd = lhsdesign(ntr,dim);
Xtr = bsxfun(@plus,lb,bsxfun(@times,xtrd,(ub-lb)));
ytr = func_eval(Eval_func,Xtr);
errtrain = c*randn(ntr,1);
ytr = ytr + errtrain;

% Split train set into train and validation sets
All_Ind = randperm(ntr);
idtr = All_Ind(1:in_tr);
idte = setdiff(All_Ind,idtr,'stable');
X_trainset = Xtr(idtr,:);
y_trainset = ytr(idtr,:);
X_validset = Xtr(idte,:);
y_validset = ytr(idte,:);

sn = rand(1,1);
num_hypers = eval(feval(covfunc{:}));
hypers = rand(num_hypers,1);
hyp.cov = log(hypers); hyp.mean = []; hyp.lik = log(sn);