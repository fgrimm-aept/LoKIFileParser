@enum ionizationOperatorType begin
    conservative = 0
    oneTakesAll = 1
    equalSharing = 2
    usingSDCS = 3
end

@enum ionizationScattering begin
    isotropic = 0
    anisotropic = 1
end

@enum eedfType begin
    boltzmann = 0 
    prescribeEedf = 1
    boltzmannMC = 2
end

@enum growthModelType begin
    temporal = 0
    spatial = 1
end

@enum gasTemperatureEffect begin
    False = 0
    True = 1
    smartActivation = 2
end

@enum algorithm begin
    mixingDirectSolutions = 0
    temporalIntegration = 1
end
