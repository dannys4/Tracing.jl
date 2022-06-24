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
        texture_index = parse(_INT_TYPE, fs[2])
    elseif num_eltz == 3
        length(fs[2]) > 0 && (texture_index = parse(_INT_TYPE, fs[2]))
        normal_index = parse(_INT_TYPE, fs[3])
    end

    return vertex_index, texture_index, normal_index
end

function parseOBJ(filename::String; big_matrix=false)#::PolyObject
    # Read the file
    vs = SVector{3, _FLOAT_TYPE}[]
    vts = SVector{3, _FLOAT_TYPE}[]
    vns = SVector{3, _FLOAT_TYPE}[]
    fs = SVector{9, _INT_TYPE}[]  # p1face, p1texture, p1normal, p2face, p2texture, p2normal, p3face, p3texture, p3normal
    
    for line in eachline(filename)
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
    
    if big_matrix
        # p1_x, p1_y, p1_z, p2_x, p2_y, p2_z, p3_x, p3_y, p3_z, p1T_x, p1T_y, ...
        has_texture = all(f[2] > 0 for f in fs)
        has_normal = all(f[3] > 0 for f in fs)
        faces = Matrix{_FLOAT_TYPE}(undef, length(fs), 27)

        for j in eachindex(fs)
            face = fs[j]
            faces[j,1:9] = reduce(vcat, vs[face[1:3:end]])
            if has_texture
                faces[j,10:18] = reduce(vcat, vts[face[2:3:end]])
            end
            if has_normal
                faces[j,19:27] = reduce(vcat, vns[face[3:3:end]])
            else
                faces[j,19:27] = repeat(normalVec(faces[j,1:9]), 3, 1)
            end
        end
        return faces
    end
    reduce(hcat, vs), has_textures ? reduce(hcat, vts) : nothing, has_normals ? reduce(hcat, vns) : nothing, fs
end

faces = parseOBJ("data/Sonic/Sonic.obj", big_matrix=true)
