function sampleEpsi!(mats::HybridMatrices,current::QTL.Current,out::QTL.Output)
    yCorr         = current.yCorr
    varRes        = current.varResidual
    λ             = current.varResidual/current.varEffects
    iIter         = 1/current.iter
    Z_n           = mats.Z._n
    Ai_nn         = mats.Ai.nn
    meanEpsi      = out.meanEpsi
    ϵ             = current.ϵ

    #add back {Zn'Zn}_{i,i} *ϵ
    current.yCorr = current.yCorr + Z_n*ϵ
    rhs = Z_n'current.yCorr

    lhs = Z_n'Z_n+Ai_nn*λ #better to construct Z_n'Z_n outside

    sample_random_rhs!(lhs,rhs,current,out) #use this general function for sample epsilon(Gianola Book)

    current.yCorr = current.yCorr - Z_n*ϵ
end

#with known variances
function sampleEpsi!(mats::HybridMatrices,current::QTL.Current,out::QTL.Output,lhsCol,lhsDi,sd)
    Z_n  = mats.Z._n
    yCorr= current.yCorr
    ϵ    = current.ϵ


    #current.yCorr = current.yCorr + Z_n*ϵ #maybe yCorr[:] = yCorr[:] - Z_1*ϵ better
    yCorr[:] = yCorr[:] + Z_n*ϵ
    #rhs = Z_n'current.yCorr
    rhs = Z_n'yCorr

    sample_random_rhs!(lhsCol,rhs,current,out,lhsDi,sd)

    #current.yCorr = current.yCorr - Z_n*ϵ
    yCorr[:] = yCorr[:] - Z_n*current.ϵ
end
