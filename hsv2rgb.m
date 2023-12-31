
function [rout,g,b] = hsv2rgb(hin,s,v)

%HSV2RGB Convert hue-saturation-value colors to red-green-blue.

%   M = HSV2RGB(H) converts an HSV color map to an RGB color map.

%   Each map is a matrix with any number of rows, exactly three columns,

%   and elements in the interval 0 to 1.  The columns of the input matrix,

%   H, represent hue, saturation and value, respectively.  The columns of

%   the resulting output matrix, M, represent intensity of red, blue and

%   green, respectively.

%

%   RGB = HSV2RGB(HSV) converts the HSV image HSV (3-D array) to the

%   equivalent RGB image RGB (3-D array).

%

%   As the hue varies from 0 to 1, the resulting color varies from

%   red, through yellow, green, cyan, blue and magenta, back to red.

%   When the saturation is 0, the colors are unsaturated; they are

%   simply shades of gray.  When the saturation is 1, the colors are

%   fully saturated; they contain no white component.  As the value

%   varies from 0 to 1, the brightness increases.

%

%   The colormap HSV is hsv2rgb([h s v]) where h is a linear ramp

%   from 0 to 1 and both s and v are all 1's.

%

%   See also RGB2HSV, COLORMAP, RGBPLOT.

 

%   Undocumented syntaxes:

%   [R,G,B] = HSV2RGB(H,S,V) converts the HSV image H,S,V to the

%   equivalent RGB image R,G,B.

%

%   RGB = HSV2RGB(H,S,V) converts the HSV image H,S,V to the 

%   equivalent RGB image stored in the 3-D array (RGB).

%

%   [R,G,B] = HSV2RGB(HSV) converts the HSV image HSV (3-D array) to

%   the equivalent RGB image R,G,B.

 

%   See Alvy Ray Smith, Color Gamut Transform Pairs, SIGGRAPH '78.

%   Copyright 1984-2011 The MathWorks, Inc. 

 

if nargin == 1 % HSV colormap

    threeD = ndims(hin)==3; % Determine if input includes a 3-D array

    if threeD

        h = hin(:,:,1); s = hin(:,:,2); v = hin(:,:,3);

    else

        h = hin(:,1); s = hin(:,2); v = hin(:,3);

    end

elseif nargin == 3

    if ~isequal(size(hin),size(s),size(v))

        error(message('MATLAB:hsv2rgb:InputSizeMismatch'));

    end

    h = hin;

else

    error(message('MATLAB:hsv2rgb:WrongInputNum'));

end    

        

h = 6.*h;

k = floor(h);

p = h-k;

t = 1-s;

n = 1-s.*p;

p = 1-(s.*(1-p));

 

% Processing each value of k separately to avoid simultaneously storing

% many temporary matrices the same size as k in memory

kc = (k==0 | k==6);

r = kc;

g = kc.*p;

b = kc.*t;

 

kc = (k==1);

r = r + kc.*n;

g = g + kc;

b = b + kc.*t;

 

kc = (k==2);

r = r + kc.*t;

g = g + kc;

b = b + kc.*p;

 

kc = (k==3);

r = r + kc.*t;

g = g + kc.*n;

b = b + kc;

 

kc = (k==4);

r = r + kc.*p;

g = g + kc.*t;

b = b + kc;

 

kc = (k==5);

r = r + kc;

g = g + kc.*t;

b = b + kc.*n;

 

if nargout <= 1

    if nargin == 3 || threeD 

        rout = cat(3,r,g,b);

    else

        rout = [r g b];

    end

    rout = bsxfun(@times, v./max(rout(:)), rout);

else

    f = v./max([max(r(:)); max(g(:)); max(b(:))]);

    rout = f.*r;

    g = f.*g;

    b = f.*b;

end


