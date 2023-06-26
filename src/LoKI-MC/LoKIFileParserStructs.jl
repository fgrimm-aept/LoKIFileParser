using Base: @kwdef

@kwdef mutable struct OutputMC <: Output
    isOn::Bool = true
    folder::String = "test"
    dataFiles::Vector{String} = ["eedf", "evdf", "swarmParameters",
        "rateCoefficients", "powerBalance", "MCSimDetails",
        "MCTemporalInfo", "lookUpTable"]
end

@kwdef mutable struct GuiMC <: Gui
    isOn::Bool = true
    fontSize::Int64 = 9
    plotOptions::Vector{String} = [
        "",
        # "MCTemporalInfo",
        # "distributionFunctions",
        # "swarmParameters",
        # "powerBalance",
    ]
    terminalDisp::Vector{String} = ["setup", "MCStatus"]
end

@kwdef mutable struct RelErrorMC <: RelError
    meanEnergy::Float64 = 1E-3
    fluxDriftVelocity::Float64 = 1E-2
    fluxDiffusionCoeffs::Float64 = 1.5E-2
    powerBalance::Float64 = 1E-4
end

@kwdef mutable struct NumericsMC <: Numerics
    nElectrons::Float64 = 1E4
    gasTemperatureEffect::String = "smartActivation"
    nIntegrationPoints::Float64 = 3E4
    # nIntegratedSSTimes::Int64 = 10                 # number of integrated steady-state times
    # maxCollisionsBeforeSteadyState::Float64 = 5E4  # maximum number of collisions per electron before the steady-state is considered
    # maxCollisionsAfterSteadyState::Float64 = 5E4   # maximum number of collisions per electron after the steady-state is reached
    # relError::RelError = RelErrorMC()                # tolerances for the relative errors of the MC results
    # nInterpPoints::Float64 = 1E4
    # nEnergyCells::Int64 = 500
    # nCosAngleCells::Int64 = 50
    # nAxialVelocityCells::Int64 = 200
    # nRadialVelocityCells::Int64 = 200
end

@kwdef mutable struct StatePropertiesMC <: StateProperties
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

@kwdef mutable struct GasPropertiesMC <: GasProperties
    mass::String = "Databases/masses.txt"
    fraction::Vector{String} = ["H2O = 1"]
    harmonicFrequency::String = "Databases/harmonicFrequencies.txt"
    anharmonicFrequency::String = "Databases/anharmonicFrequencies.txt"
    rotationalConstant::String = "Databases/rotationalConstants.txt"
    electricQuadrupolMoment::String = "Databases/quadrupoleMoment.txt"
    OPBParameter::String = "Databases/OPBParameter.txt"
end

@kwdef mutable struct ElectronKinecticsMC <: ElectronKinectics
    isOn::Bool = true
    eedfType::String = "boltzmannMC"
    shapeParameter::Float64 = 1.0  # Range between 1.0 (Maxwellian) to 2.0 (Druyvesteyn), only relevant if eedfType(1) is set
    ionizationOperatorType::String = "usingSDCS"
    ionizationScattering::String = "isotropic"
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
    gasProperties::GasPropertiesMC = GasPropertiesMC()
    stateProperties::StatePropertiesMC = StatePropertiesMC()
    numericsMC::NumericsMC = NumericsMC()
end

@kwdef mutable struct WorkingConditionsMC <: WorkingConditions
    reducedElecField::Vector{Float64} = collect(150:10:350)
    gasPressure::Float64 = 101325
    gasTemperature::Float64 = 3000
end

@kwdef mutable struct LoKIFileMC <: LoKIFile
    workingConditions::WorkingConditionsMC = WorkingConditionsMC()
    electronKinectics::ElectronKinecticsMC = ElectronKinecticsMC()
    gui::GuiMC = GuiMC()
    output::OutputMC = OutputMC()
end


