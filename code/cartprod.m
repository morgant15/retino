function result = cartprod(p, q)

if iscellstr(p) || iscellstr(q)
    result = cell([length(p) * length(q), 2]);
elseif isnumeric(p) && isnumeric(q)
    result = zeros([length(p) * length(q), 2]);
else
    error('Only cellstr and numeric arrays are supported');
end

% start always from the one with fewer elements
swapped = 0;
if length(p) > length(q)
    tmp = p;
    p = q;
    q = tmp;
    swapped = 1;
end

np = length(p);
nq = length(q);

% check we have column arrays (2nd dimension largest)
if size(p, 2) > size(p, 1)
    p = p';
end
if size(q, 2) > size(q, 1)
    q = q';
end

for i = 0:np-1
   result(i*nq+1:(i+1)*nq, :) = [repmat(p(i+1), [nq, 1]), q];
end
% order counts in cart prod
if swapped
   result = sortrows(result(:, [2 1]));
end
end