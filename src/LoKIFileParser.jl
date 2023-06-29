module LoKIFileParser

# Abstract structs
export LoKIFile,
    WorkingConditions,
    ElectronKinectics, GasProperties, StateProperties,
    Numerics, EnergyGrid,
    NonLinearRoutines, ODESetParameters, RelError, SmartGrid,
    Chemistry, Gui, Output

# LoKI-MC structs
export LoKIFileMC,
    WorkingConditionsMC,
    ElectronKinecticsMC, GasPropertiesMC, StatePropertiesMC,
    NumericsMC, EnergyGridMC, RelErrorMC,
    ChemistryMC, GuiMC, OutputMC

# LoKI-B structs
export LoKIFileB,
    WorkingConditionsB,
    ElectronKinecticsB, GasPropertiesB, StatePropertiesB,
    NumericsB, EnergyGridB, SmartGridB,
    NonLinearRoutinesB, ODESetParametersB,
    ChemistryB, GuiB, OutputB

# Enums
# export eedfType, ionizationOperatorType, ionizationScattering,
# growthModelType, gasTemperatureEffect, algorithm

export write_LoKI, read_LoKI
export set_gasfraction!, set_gasfraction
export set_reducedField!, set_reducedField
export set_enable_gui!, set_enable_gui


include("LoKIFileParserAbstract.jl")
# include("LoKIFileParserEnums.jl")

include("LoKI-B/LoKIFileParserStructs.jl")
include("LoKI-MC/LoKIFileParserStructs.jl")

include("LoKIFileParserRead.jl")
include("LoKIFileParserWrite.jl")

include("LoKIFileParserUtils.jl")

end