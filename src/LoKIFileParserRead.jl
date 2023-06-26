STRUCT_DICT = Dict(
    :LoKIFileMC => [
        :WorkingConditionsMC,
        :ElectronKinecticsMC,
        :GasPropertiesMC,
        :StatePropertiesMC,
        :NumericsMC,
        :GuiMC,
        :OutputMC],
    :LoKIFileB => [
        :WorkingConditionsB,
        :ElectronKinecticsB,
        :GasPropertiesB,
        :StatePropertiesB,
        :NumericsB,
        :GuiB,
        :OutputB]
)

function get_indentationlevel(line)
    return length(line) - length(lstrip(line))
end

function remove_comments!(data::Vector{String})
    for (idx, line) in enumerate(data)
        if occursin("%", line)
            datamask = findfirst(r"\s+%.*", line) # find comments in data and remove them together with whitespace
            data[idx] = line[1:datamask[1]-1]
        end
    end
    return data
end

function remove_empty_lines!(data::Vector{String})
    for (idx, line) in enumerate(data)
        chars = Char[]
        for s in line
            char = Char(s)
            push!(chars, char)
        end
        if all(isspace.(chars))
            data[idx] = ""
        end
    end
end

function clean_data!(data::Vector{String})
    remove_empty_lines!(data)
    datamask = @. isempty(data)
    deleteat!(data, datamask)
    datamask = @. startswith(lstrip(data), "%") # filters out comment lines (starting with %)
    deleteat!(data, datamask)
    remove_comments!(data)
end

function key_val_split(data::Vector{String})
    keys = String[]
    values = String[]
    for elem in data
        if startswith(strip(elem), '-')
            key = ""
            value = strip(elem)
        else
            key, value = split(elem, ':')
            key, value = strip(key), strip(value)
        end
        push!(keys, key)
        push!(values, value)
    end
    return keys, values
end

function return_ranges(idxs::Vector{Int64})
    ranges = []
    for elem in length(idxs) - 1
        push!(ranges, idxs[elem]:idxs[elem+1])
    end
    return ranges
end

function analyse_data(data::Vector{String})
    keyvals, vals = key_val_split(data)
    lvls = get_indentationlevel.(data)
    return keyvals, vals, lvls
end

function parse_data(data::Tuple, type::Symbol, idx::Int64=0)
    ident = replace(string(type), string(LoKIFile) => "")
    keys, values, levels = reverse.(data)
    reverse.(data)
    contents = []
    objs = []
    prev = levels[1]
    for i in eachindex(keys)

        if startswith(values[i], '-')
            push!(contents, strip(values[i], ['-', ' ']))

        elseif isempty(values[i])
            push!(contents, values[i])

        elseif !isempty(keys[i]) && isempty(values[i]) && levels[i] < prev
            push!(objs, Symbol(keys[i]) => contents)
            contents = []

        elseif !isempty(keys[i]) && !isempty(values[i])
            push!(objs, Symbol(keys[i] * ident) => values[i])
        end
        prev = levels[i]
    end

    return

end

function find_idxs(keyvals::Vector{String})
    workingConditions_idx = findfirst(x -> occursin("workingConditions", x), keyvals)
    electronKinetics_idx = findfirst(x -> occursin("electronKinetics", x), keyvals)
    gasProperties_idx = findfirst(x -> occursin("gasProperties", x), keyvals)
    stateProperties_idx = findfirst(x -> occursin("stateProperties", x), keyvals)
    numerics_idx = findfirst(x -> occursin("numerics", x), keyvals)
    gui_idx = findfirst(x -> occursin("gui", x), keyvals)
    output_idx = findfirst(x -> occursin("output", x), keyvals)

    idxs = [workingConditions_idx, electronKinetics_idx, gasProperties_idx, stateProperties_idx, numerics_idx, gui_idx, output_idx]
    return idxs
end

function prepare_datablocks(keyvals::Vector{String}, type::Symbol)
    idxs = find_idxs(keyvals)
    structs = STRUCT_DICT[type]
    key_idxs = Pair.(structs, idxs)
    sort!(key_idxs, by=x -> x.second)
    idxs = [x.second for x in key_idxs]
    elements = [
        key_idxs[1].first => collect(idxs[1]:idxs[2]-1),
        key_idxs[2].first => collect(idxs[2]:idxs[3]-1),
        key_idxs[3].first => collect(idxs[3]:idxs[4]-1),
        key_idxs[4].first => collect(idxs[4]:idxs[5]-1),
        key_idxs[5].first => collect(idxs[5]:idxs[6]-1),
        key_idxs[6].first => collect(idxs[6]:idxs[7]-1),
        key_idxs[7].first => collect(idxs[7]:length(keyvals)),
    ]
    return elements
end

function convert_arg!(arg, args, idx)
    if startswith(arg.second, '[') && endswith(arg.second, ']')
        vals_str = split(strip(arg.second, ['[', ']']), ',')
        vals = parse.(Float64, vals_str)
        args[idx] = arg.first => vals
    elseif occursin(arg.second, "logspace")
        vals_str = replace(arg.second, "logspace" => "", "(" => "", ")" => "")
        start, stop, len = parse.(Float64, split(vals_str, ","))
        args[idx] = arg.first => exp10.(range(start, stop=stop, length=Int(len)))
    elseif occursin(arg.second, "linspace")
        vals_str = replace(arg.second, "linspace" => "", "(" => "", ")" => "")
        start, stop, len = parse.(Float64, split(vals_str, ","))
        args[idx] = arg.first => collect(range(start, stop=stop, length=Int(len)))
    end
end

function parse_datablocks(elements, keyvals, vals, lvls)
    objs = []
    for element in elements
        contents = String[]
        args = Pair{Symbol,Any}[]
        obj = eval(element.first)
        for i in reverse(element.second)
            k, v, l = keyvals[i], vals[i], lvls[i]
            if l == 0
                for (idx, arg) in enumerate(args)
                    if arg.second isa String && tryparse(Bool, arg.second) !== nothing
                        args[idx] = arg.first => parse(Bool, arg.second)
                    elseif in(:reducedField, arg) || in(:reducedElecField, arg)
                        convert_arg!(arg, args, idx)
                    elseif arg.second isa String && tryparse(Float64, arg.second) !== nothing
                        args[idx] = arg.first => parse(Float64, arg.second)
                    elseif isempty(arg.second) && arg.second isa Vector
                        args[idx] = arg.first => [""]
                    end
                end
                push!(objs, obj(; args...))
            elseif isempty(k) && !isempty(v) && startswith(v, '-')
                v = v[3:end]  # strip leading '- ' characters
                push!(contents, v)
            elseif !isempty(k) && isempty(v) && l != 0
                push!(args, Symbol(k) => contents)
                contents = String[]
            elseif !isempty(k) && !isempty(v) && l != 0
                push!(args, Symbol(k) => v)
            end
        end

    end
    return objs
end

function read_LoKI(filename::String, type::Symbol)
    type_eval = eval(type)
    type_eval !== LoKIFileMC && type_eval !== LoKIFileB && throw("$type is not of type \"LoKIFileMC\" or \"LoKIFileB\".")
    open(filename, "r") do file
        data = readlines(file)
        clean_data!(data)  # removes empty line entries
        keyvals, vals, lvls = analyse_data(data)
        datablocks = prepare_datablocks(keyvals, type)
        args = parse_datablocks(datablocks, keyvals, vals, lvls)
        return type_eval(args...)
    end

end

