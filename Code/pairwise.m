function L = pairwise(x,y)

Ax = pdist2(x,x,'squaredeuclidean');
Ay = pdist2(y,y,'squaredeuclidean');
D_addx = sum(Ax,2);
Dx = diag(D_addx);
Lx = Dx-Ax;
D_addy = sum(Ay,2);
Dy = diag(D_addy);
Ly = Dy-Ay;
L = Ly./Lx;
return;
