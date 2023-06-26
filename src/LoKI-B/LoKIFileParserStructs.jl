using Base: @kwdef

@kwdef mutable struct OutputB <: Output
    isOn::Bool = true
    folder::String = "test"
    dataFiles::Vector{String} = [
        "inputs",
        "eedf",
        # "log",
        "swarmParameters",
        "rateCoefficients",
        "powerBalance",
        "lookUpTable",
    ]
end

@kwdef mutable struct GuiB <: Gui
    isOn::Bool = true
    refreshFrequency::Int64 = 1
end

@kwdef mutable struct ODESetParametersB <: ODESetParameters
    AbsTol::Float64 = 1e-300
    RelTol::Float64 = 1e-6
    MaxStep::Float64 = 1e-7
end

@kwdef mutable struct NonLinearRoutinesB <: NonLinearRoutines
    algorithm::String = "mixingDirectSolutions"                     # mixingDirectSolutions or temporalIntegration
    mixingParameter::Float64 = 0.7                                  # mixingDirectSolutions mixing parameter from 0 to 1
    maxEedfRelError::Float64 = 1e-9                                 # maximum rel. variation for EEDF between two iterations (stop criterion)
    # odeSetParameters::ODESetParametersB = ODESetParametersB()     # optional parameters for the ode solver of the "temporalIntegration" algorithm
end

@kwdef mutable struct SmartGridB <: SmartGrid
    minEedfDecay::Int64 = 20                     # minimum number of decade-fall for the EEDF
    maxEedfDecay::Int64 = 25                     # maximum number of decade-fall for the EEDF
    updateFactor::Float64 = 0.05                 # factor used to increase or decrease the maximum value of the energy grid
end

@kwdef mutable struct EnergyGridB <: EnergyGrid
    maxEnergy::Float64 = 18.0                    # (use 18-20 for time-dependent simulations)
    cellNumber::Int64 = 1800                     # (use 1800-2000 for time-dependent simulations)
    # smartGrid::SmartGrid = SmartGrid()                      
end

@kwdef mutable struct NumericsB <: Numerics
    energyGrid::EnergyGridB = EnergyGridB()  # properties of the energy grid (in eV)
    maxPowerBalanceRelError::Float64 = 1e-9      # threshold for the relative power balance warning message (use at least 100 for time dependent simulations)
    nonLinearRoutines::NonLinearRoutinesB = NonLinearRoutinesB()
end

@kwdef mutable struct StatePropertiesB <: StateProperties
    energy::Vector{String} = [
        "H2O(X) = 0.0",
        "Water/H2O_vibEnergy_Itikawa.txt",
        "Water/H2O_rotEnergy_Tennyson.txt",
    ]
    statisticalWeight::Vector{String} = [
        "H2O(X) = 1.0",
        "H2O(X,v=*) = 1.0",
        "H2O(X,v=000,J=*) = rotationalDegeneracy_H2O",
    ]
    population::Vector{String} = [
        "H2O(X) = 1.0",
        "Water/H2O_vibPopulation.txt",
        "Water/H2O_rotPopulation.txt",
    ]
end

@kwdef mutable struct GasPropertiesB <: GasProperties
    mass::String = "Databases/masses.txt"
    fraction::Vector{String} = [
        "H2O = 1",
    ]
    harmonicFrequency::String = "Databases/harmonicFrequencies.txt"
    anharmonicFrequency::String = "Databases/anharmonicFrequencies.txt"
    rotationalConstant::String = "Databases/rotationalConstants.txt"
    electricQuadrupoleMoment::String = "Databases/quadrupoleMoment.txt"
    OPBParameter::String = "Databases/OPBParameter.txt"
end

@kwdef mutable struct ElectronKinecticsB <: ElectronKinectics
    isOn::Bool = true
    eedfType::String = "boltzmann"
    shapeParameter::Float64 = 1.0  # Range between 1.0 (Maxwellian) to 2.0 (Druyvesteyn), only relevant if eedfType(1) is set
    ionizationOperatorType::String = "equalSharing"
    growthModelType::String = "temporal"
    includeEECollisions::Bool = false
    LXCatFiles::Vector{String} = [
        "Water/LXCat/H2O_Excitation.txt",
        "Water/LXCat/H2O_Excitation_vib.txt",
        "Water/LXCat/H2O_Excitation_rot.txt",
        "Water/LXCat/H2O_Ionization.txt",
        "Water/LXCat/H2O_Elastic.txt",
        "Water/LXCat/H2O_Attachment.txt",
    ]
    # LXCatFilesExtra::String = "extra_LXCat.txt"  # extra cross section files
    # effectiveCrossSectionPopulations::Vector{String} = ["N2_effectivePop.txt"]
    # CARgases::Vector{String} = ["N2"]
    gasProperties::GasPropertiesB = GasPropertiesB()
    stateProperties::StatePropertiesB = StatePropertiesB()
    numerics::NumericsB = NumericsB()
end

@kwdef mutable struct WorkingConditionsB <: WorkingConditions
    reducedField::Vector{Float64} = collect(150:10:350)     # in Td
    electronTemperature::Float64 = 3.0                      # in eV
    excitationFrequency::Float64 = 0                        # in Hz
    gasPressure::Float64 = 101325                           # in Pa
    gasTemperature::Float64 = 3000                          # in K (average gas temperature)
    wallTemperature::Float64 = 390                          # in K   (wall temperature)
    extTemperature::Float64 = 300                           # in K   (external temperature)
    surfaceSiteDensity::Float64 = 1e19                      # in m-2 (used for surface kinetics)
    electronDensity::Float64 = 1e15                         # in m-3
    chamberLength::Float64 = 1.0                            # in m
    chamberRadius::Float64 = 1.0                            # in m
end

@kwdef mutable struct LoKIFileB <: LoKIFile
    workingConditions::WorkingConditionsB = WorkingConditionsB()
    electronKinectics::ElectronKinecticsB = ElectronKinecticsB()
    gui::GuiB = GuiB()
    output::OutputB = OutputB()
end