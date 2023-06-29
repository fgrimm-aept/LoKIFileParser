function print_vector(io::IO, data::Vector{Float64}, structoffset::Int64)
    s = " ["
    for elem in data
        s *= "$elem,"
    end
    s = rstrip(s, ',')
    s *= "]"
    println(io, s)
end

function print_vector(io::IO, data::Vector{String}, structoffset::Int64)
    print(io, "\n")
    if isempty(data[1])
        return missing
    end
    for elem in data
        println(io, " "^(4 + structoffset), "- $elem")
    end
    return nothing
end

const OFFSET_DICT = Dict(
    # LoKIFileMC
    WorkingConditionsMC => 0,
    ElectronKinecticsMC => 0,
    GasPropertiesMC => 2,
    StatePropertiesMC => 2,
    NumericsMC => 2,
    RelErrorMC => 4,
    GuiMC => 0,
    OutputMC => 0,

    # LoKIFileB
    WorkingConditionsB => 0,
    ElectronKinecticsB => 0,
    GasPropertiesB => 2,
    StatePropertiesB => 2,
    NumericsB => 2,
    EnergyGridB => 4,
    SmartGridB => 6,
    NonLinearRoutinesB => 4,
    ODESetParametersB => 6,
    GuiB => 0,
    OutputB => 0,
)


function get_leveloffset(xs)
    return OFFSET_DICT[typeof(xs)]
end

function print_structdata(io::IO, xs)
    structoffset = get_leveloffset(xs)
    for field in fieldnames(typeof(xs))
        data = getproperty(xs, field)
        print(io, " "^(2 + structoffset), "$field:")
        if data isa Vector{String}
            ismissing(print_vector(io, data, structoffset)) && continue
        elseif data isa Vector{Float64}
            print_vector(io, data, structoffset)
        elseif data isa String
            println(io, " $data")
        elseif data isa Number
            println(io, " $data")
        elseif isstructtype(typeof(data))
            print(io, data)
            # elseif data isa Enum
            #     data = lowercasefirst(string(data))
            #     println(io, " $data")
        end
    end
end

function print_functionality(io::IO, xs, xsname::String)
    println(io, xsname)
    print_structdata(io, xs)
end

Base.show(io::IO, xs::Output) = print_functionality(io, xs, "output:")
Base.show(io::IO, xs::Gui) = print_functionality(io, xs, "gui:")
Base.show(io::IO, xs::ElectronKinectics) = print_functionality(io, xs, "electronKinetics:")
Base.show(io::IO, xs::GasProperties) = print_functionality(io, xs, "")
Base.show(io::IO, xs::StateProperties) = print_functionality(io, xs, "")
Base.show(io::IO, xs::RelErrorMC) = print_functionality(io, xs, "")
Base.show(io::IO, xs::SmartGrid) = print_functionality(io, xs, "")
Base.show(io::IO, xs::EnergyGrid) = print_functionality(io, xs, "")
Base.show(io::IO, xs::NonLinearRoutines) = print_functionality(io, xs, "")
Base.show(io::IO, xs::ODESetParameters) = print_functionality(io, xs, "")
Base.show(io::IO, xs::Numerics) = print_functionality(io, xs, "")
Base.show(io::IO, xs::WorkingConditions) = print_functionality(io, xs, "workingConditions:")

function Base.show(io::IO, xs::LoKIFile)
    for field in fieldnames(typeof(xs))
        println(io, getproperty(xs, field))
    end
end

function create_backup(filename::String)
    open(filename, "r") do file
        open(filename * ".backup", "w") do backup
            data = readlines(file)
            for line in data
                println(backup, line)
            end
        end
    end
end

function write_LoKI(filename::String, xs::LoKIFile)
    create_backup(filename)
    open(filename, "w") do file
        println(file, xs)
    end
end

function restore_from_backup(filename::String, xs::LoKIFile)
    open(filename * ".backup", "r") do backup
        open(filename, "w") do file
            data = readlines(backup)
            [println(file, line) for line in data]
        end
    end
end
