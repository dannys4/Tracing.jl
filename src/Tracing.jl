module Tracing
using Images, StaticArrays
# Write your package code here.

# class camera?
## Produces rays
# - rotation (euler angles)
# - position

# class ray
# - pt + dir

# class object
# query(object, pt) -> normal vector, reflectance (r,g,b)

# class light source
# - position
# - color

# class scene
# - objects
# - camera
# - background color
# - ambient light

abstract type AbstractRay end
abstract type AbstractCamera end
abstract type AbstractMesh end
abstract type AbstractObject end
abstract type AbstractLightSource end

const _FLOAT_TYPE = Float32
const _INT_TYPE = Int16

struct CPURay <: AbstractRay
    point::SVector{3,_FLOAT_TYPE}
    direction::SVector{3,_FLOAT_TYPE}
end

struct CPUCamera <: AbstractCamera
    position::SVector{3,_FLOAT_TYPE}
    rotation::SVector{3,_FLOAT_TYPE}
end

struct PolyObject <: AbstractObject
    vertices::AbstractMatrix{_FLOAT_TYPE}
    faces::AbstractMatrix{_INT_TYPE}
    texture::AbstractMatrix{_FLOAT_TYPE}
end

function PolyObject(file)

end

type 
    Object* = object
        vertices: seq[Point]
        faces: seq[Face]

end


