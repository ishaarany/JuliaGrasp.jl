using JuliaGrasp
using Test

@testset "JuliaGrasp.jl" begin
    filepath = "/home/ibs/GRASP2018/work/k"
    Basics.Execute(RnucleusCmd.Rnucleus(calc_dir=filepath, Z=2, A=2, neutralMass=2.1));
    configurations=
                    [
                        "2s(2,*)2p(2,*)",
                        "2p(4,*)", 
                        "2s(2,*)2p(1,*)3p(1,*)",
                        "2s(1,*)2p(2,*)3s(1,*)",
                        "2s(1,*)2p(2,*)3d(1,*)",
                        "2p(3,*)3p(1,*)",
                        "2s(2,*)3d(2,*)",
                    ];
    active_orbitals="3s,3p,3d"
    configs = RcsfgenerateCmd.Configurations(core="He", Configs=configurations);
    rcsfgenerate = RcsfgenerateCmd.Rcsfgenerate(calc_dir=filepath, 
                                                Configs=configs,
                                                Jl=0,
                                                Jh=10,
                                                noex=0,
                                                active_orbitals=active_orbitals)
    Basics.Execute(rcsfgenerate)


    #  Rangular
    rangular= RangularCmd.Rangular(calc_dir=filepath)
    Basics.Execute(rangular)

    rwfnestimate= RwfnestimateCmd.Rwfnestimate(calc_dir=filepath)
    Basics.Execute(rwfnestimate)

    rmcdhf= RmcdhfCmd.Rmcdhf(calc_dir=filepath)
    # Basics.Execute(rmcdhf)

end
