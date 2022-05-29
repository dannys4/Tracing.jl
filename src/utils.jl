
function crossProd(a, b)
    [a[2] * b[3] - a[3] * b[2], a[3] * b[1] - a[1] * b[3], a[1] * b[2] - a[2] * b[1]]
end

function normalVec(v)
    x = crossProd(v[4:6]-v[1:3], v[7:9]-v[1:3])
    x = x / norm(x)
end