using .LoKIFileParser: LoKIFileMC, LoKIFileB

function set_reducedField!(obj::LoKIFileB, values::Vector{T} where {T<:Number})
    resize!(obj.workingConditions.reducedField, length(values))
    @. obj.workingConditions.reducedField = values
end

set_reducedField(obj::LoKIFileB, values::Vector{T} where {T<:Number}) = set_reducedField!(deepcopy(obj), values)

function set_reducedField!(obj::LoKIFileMC, values::Vector{T} where {T<:Number})
    resize!(obj.workingConditions.reducedElecField, length(values))
    @. obj.workingConditions.reducedElecField = values
end

set_reducedField(obj::LoKIFileMC, values::Vector{T} where {T<:Number}) = set_reducedField!(deepcopy(obj), values)

function set_gasfraction!(obj::LoKIFileB, values::Vector{Pair})
    resize!(obj.electronKinectics.gasProperties.fraction, length(values))
    @. obj.electronKinectics.gasProperties.fraction = [replace(string(k, " = ", v), "(t)" => "") for (k, v) in values]
end

set_gasfraction(obj::LoKIFileB, values::Vector{Pair}) = set_gasfraction!(deepcopy(obj), values)

function set_gasfraction!(obj::LoKIFileMC, values::Vector{Pair})
    resize!(obj.electronKinectics.gasProperties.fraction, length(values))
    @. obj.electronKinectics.gasProperties.fraction = [replace(string(k, " = ", v), "(t)" => "") for (k, v) in values]
end

set_gasfraction(obj::LoKIFileMC, values::Vector{Pair}) = set_gasfraction!(deepcopy(obj), values)

function set_enable_gui!(obj::LoKIFile, value::Bool)
    obj.gui.isOn = value
    nothing
end

set_enable_gui(obj::LoKIFile, value::Bool) = set_enable_gui!(deepcopy(obj), value)
