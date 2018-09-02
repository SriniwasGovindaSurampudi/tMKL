function[ts] = get_eig_decomp(fc)
[v, l] = eig(fc);
l_d = diag(l);
first = find(l_d>0);

if isempty(first)
    
    ts = [];
    
else
    
    first = first(1);
    v = v(:, first:end);
    l = sqrt(l(first:end, first:end));
    ts = l * v';
    
end

end