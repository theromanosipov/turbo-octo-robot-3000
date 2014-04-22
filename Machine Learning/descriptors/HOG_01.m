Im = imread('C:\Users\Roman\Desktop\123.jpg');
Im = rgb2gray(Im);
imshow(Im);

ImH = size(Im, 1);
ImW = size(Im, 2);

HOGxy = zeros(ImH, ImW, 2);
HOGld = zeros(ImH, ImW, 2);

for i = 2:ImW - 1
    for j = 2:ImH - 1
        HOGxy(j, i, 1) = -double(Im(j, i-1)) + double(Im(j, i+1));
        HOGxy(j, i, 2) = -double(Im(j-1, i)) + double(Im(j+1, i));
        HOGld(j, i, 1) = sqrt(HOGxy(j, i, 1)^2 + HOGxy(j, i, 2)^2);
        if (HOGxy(j, i, 1) == 0) && (HOGxy(j, i, 2) == 0)
            HOGld(j, i, 2) = 0;
        else
            HOGld(j, i, 2) = atan(HOGxy(j, i, 2) / HOGxy(j, i, 1));
        end;
    end;
end;
HOGld(:, :, 2) = (HOGld(:, :, 2) + pi / 2) / pi * 180;
HOGld(:, :, 2) = idivide(uint8(HOGld(:, :, 2)), 21, 'fix');
HOGld(:, :, 2) = HOGld(:, :, 2) + 1;

imshow(uint8(HOGld(:, :, 1)));
    
bucket = zeros(9 * 9);

hists = zeros (ImH / 6, ImW / 6, 9);

for i = 1 : ImH / 6
    for j = 1 : ImW / 6
        for k = (i - 1) * 6 + 1 : (i - 1) * 6 + 1 + 2
            for l = (j - 1) * 6 + 1 : (j - 1) * 6 + 1 + 2
                hists(i, j, HOGld(k, l, 2)) = hists(i, j, HOGld(k, l, 2)) + HOGld(k, l, 1);
            end;
        end;
    end;
end;

result = zeros(ImH / 6 - 2, ImW / 6 - 2, 9 * 9);

for i = 1 : ImH / 6 - 2
    for j = 1 : ImW / 6 - 2
        z = 1;
        for k = i : i + 2
            for l = j : j + 2
                result(i , j, z:z+8) = hists(k, l, :);
                z = z + 9;
            end;
        end;
    end;
end;

for i = 1 : ImH / 6 - 2
    for j = 1 : ImW / 6 - 2
        norm = 0.0;
        for k = 1:81
            norm = norm + result(i, j, k)^2;
        end;
        norm = sqrt(norm) + 0.0001;
        result(i, j, :) = result(i, j, :) / norm;
    end;
end;

clear HOGld HOGxy hists Im;

%{
result1D = zeros((ImH / 6 - 2) * (ImW / 6 - 2) * 81, 'double');

z = 1;
for i = 1 : ImH / 6 - 2
    for j = 1 : ImW / 6 - 2
        result1D(z:z+80) = result(i, j, :);
        z = z + 81;
    end;
end;
%}