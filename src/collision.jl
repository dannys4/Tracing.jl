# funciton that takes ray, computes intersection point with object, returns intersection point + color + 


function getCollisionFace(face::AbstractVector{_FLOAT_TYPE}, ray::AbstractRay)::Union{Nothing, NTuple{3,AbstractVector{_FLOAT_TYPE}}}
    # face is 1x9?
    
    p1 = face[1:3]
    p2 = face[4:6]
    p3 = face[7:9]

    n = normalVec(face)
    d = n'p1

    t = (d - n' ray.base) / (n' ray.direction) 

    if t <= 0
        return nothing
    end

    # q = ray.base + t * ray.direction
    area = crossProd(p2 - p1, p3 - p1)' n
    b1 = crossProd(p3 - p2, q - p2)' n / area
    b2 = crossProd(p1 - p3, q - p3)' n / area
    b3 = crossProd(p2 - p1, q - p1)' n / area

    if b1 >= 0 && b2 >= 0 && b3 >= 0
        return b1, b2, b3
    end
    
    nothing
end

function getCollisionObject(object, ray)
    for (idx,face) in enumerate(object)
        x = getCollisionFace(face, ray)
        if !isnothing(x)
            return x, idx
        end
    end
    return nothing
end