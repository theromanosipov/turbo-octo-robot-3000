run('C:\Users\Roman\Documents\GitHub\turbo-octo-robot-3000\lib\vlfeat\toolbox\vl_setup')

I = imread('C:\Users\Roman\Desktop\robot300x480.jpg') ;
I = double(I) / 256 ;

Ih = size(I, 1);
Iw = size(I, 2);

image(I) ;

I = single(rgb2gray(I)) ;

f = vl_sift(I) ;

for i = 1:size(f, 2)
    if int16( f(2,i) - 8 ) > 0 &&  int16( f(2,i) + 7 ) < Ih && int16( f(1,i) - 8 ) > 0 && int16( f(1,i) + 7 ) < 0
        m1 = I( int16( f(2,i) - 8 ) : int16( f(2,i) + 7 ), int16( f(1,i) - 8 ) : int16( f(1,i) + 7 ) );
            % Iena per 4 x 4 blokus, kurie susideda iš 4 x 4 pixeli?
            for j1 = 0:3
                for j2 = 0:3
end;
