%
% Copyright 2001 Free Software Foundation, Inc.
% 
% This file is part of GNU Radio
% 
% GNU Radio is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3, or (at your option)
% any later version.
% 
% GNU Radio is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with GNU Radio; see the file COPYING.  If not, write to
% the Free Software Foundation, Inc., 51 Franklin Street,
% Boston, MA 02110-1301, USA.
% 

function v = read_complex_binary(filename, count, start)

  %% usage: read_complex_binary (filename, [count])
  %%
  %%  open filename and return the contents as a column vector, 
  %%  treating them as 32 bit interleaved float complex numbers
  %%

%   warning('should use readComplexBinary. Proper error checking, faster, and returns data as single the same was as stored in file')

  m = nargchk (1,3,nargin);
  if (m)
    usage (m);
  end

  if (nargin < 2)
    count = Inf;
  end

  if (nargin <3)
      start=0;
  end 
  
  f = fopen (filename, 'rb');
  if (f < 0)
    v = 0;
  else
    s = fseek(f,4*2*start,-1);
    t = fread (f, [2, count], 'float');
    fclose (f);
    v = t(1,:) + t(2,:)*i;
    [r, c] = size (v);
    v = reshape (v, c, r);
  end