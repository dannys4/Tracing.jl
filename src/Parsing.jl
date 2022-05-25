const VERTEX = "v "
const VERTEX_TEXTURE = "vt "
const VERTEX_NORMAL = "vn "
const USEMTL = "usemtl"
const FACE = "f "
# ignore all others

function parseFaceItem(f::AbstractString)::NTuple{3,_INT_TYPE}
    fs = split(f, "/")
    num_eltz = length(fs)

    vertex_index = parse(_INT_TYPE, fs[1])
    texture_index = 0
    normal_index = 0

    if num_eltz == 2
        texture_index == parse(_INT_TYPE, fs[2])
    elseif num_eltz == 3
        length(fs[2]) > 0 && (texture_index = parse(_INT_TYPE, fs[2]))
        normal_index = parse(_INT_TYPE, fs[3])
    end

    return vertex_index, texture_index, normal_index
end

function parseOBJ(filename::String)#::PolyObject
    # Read the file
    vs = SVector{3, _FLOAT_TYPE}[]
    vts = SVector{3, _FLOAT_TYPE}[]
    vns = SVector{3, _FLOAT_TYPE}[]
    fs = SVector{9, _INT_TYPE}[]
    
    for (j, line) in enumerate(eachline(filename))
        if startswith(line, VERTEX)
            v1, v2, v3 = parse.((_FLOAT_TYPE,), split(line, r"\s+")[2:end])
            push!(vs, SVector{3, _FLOAT_TYPE}(v1, v2, v3))
        elseif startswith(line, VERTEX_TEXTURE)
            v1, v2, v3 = parse.((_FLOAT_TYPE,), split(line, r"\s+")[2:end])
            push!(vts, SVector{3, _FLOAT_TYPE}(v1, v2, v3))
        elseif startswith(line, VERTEX_NORMAL)
            v1, v2, v3 = parse.((_FLOAT_TYPE,), split(line, r"\s+")[2:end])
            push!(vns, SVector{3, _FLOAT_TYPE}(v1, v2, v3))
        elseif startswith(line, USEMTL)
            # let's do nothing for now
        elseif startswith(line, FACE)
            sp1, sp2, sp3 = split(line, r"\s+")[2:end]
            f1, f2, f3 = parseFaceItem.((sp1, sp2, sp3))
            push!(fs, SVector(f1..., f2..., f3...))  # woomy
        else
            # ignore all others
        end
    end
    vs, vts, vns, fs
end

parseOBJ("data/Sonic.obj")
