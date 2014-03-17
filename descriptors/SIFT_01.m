run('C:\Users\Roman\Documents\GitHub\turbo-octo-robot-3000\lib\vlfeat\toolbox\vl_setup')

I = imread('C:\Users\Roman\Desktop\robot300x480.jpg') ;
I = double(I) / 256 ;

image(I) ;

I = single(rgb2gray(I)) ;

[f,d] = vl_sift(I) ;

perm = randperm(size(f,2)) ;
sel = perm(50:100) ;
h1 = vl_plotframe(f(:,sel)) ;
h2 = vl_plotframe(f(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;

h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
set(h3,'color','g') ;
