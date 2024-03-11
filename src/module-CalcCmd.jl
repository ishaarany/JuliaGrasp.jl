"""
`module  JuliaGrasp.CalcCmd`  
    ... a submodel of JuliaGRASP that use to run GRASP commands:
                                                    Rnucleus
                                                    Rcsfgenerate
                                                    Rangular
                                                    Rcsfinteract
                                                    Rwfnestimate
                                                    Rmcdhf
                                                    Rci
                                                    Jj2lsj
                                                    Rlevels
    in one shot
"""
module CalcCmd

    using ..Basics, ..DefaultModule, FieldDefaults,..RnucleusCmd, ..RcsfgenerateCmd, ..RangularCmd, ..RcsfinteractCmd, ..RwfnestimateCmd, ..RmcdhfCmd, ..RciCmd, ..Jj2lsjCmd, ..RlevelsCmd

    export Execute, Calc

    abstract type AbstractCalc  end

    @default_kw mutable struct  Calc <: AbstractCalc
        default                  ::DefaultModule.Default
        rnucleus                 ::RnucleusCmd.Rnucleus
        rcsfgenerate             ::RcsfgenerateCmd.Rcsfgenerate
        rangular                 ::RangularCmd.Rangular
        rcsfinteract             ::RcsfinteractCmd.Rcsfinteract    
        rwfnestimate             ::RwfnestimateCmd.Rwfnestimate    
        rmcdhf                   ::RmcdhfCmd.Rmcdhf
        rci                      ::RciCmd.Rci
        jj2lsj                   ::Jj2lsjCmd.Jj2lsj
        rlevels                  ::RlevelsCmd.Rlevels
    end

    function Calc(
            default                  ::DefaultModule.Default, 
            rnucleus                 ::RnucleusCmd.Rnucleus,
            rcsfgenerate             ::RcsfgenerateCmd.Rcsfgenerate,
            rangular                 ::Union{Nothing, RangularCmd.Rangular},
            rcsfinteract             ::Union{Nothing, RcsfinteractCmd.Rcsfinteract},
            rwfnestimate             ::Union{Nothing, RwfnestimateCmd.Rwfnestimate},
            rmcdhf                   ::Union{Nothing, RmcdhfCmd.Rmcdhf},
            rci                      ::Union{Nothing, RciCmd.Rci},
            jj2lsj                   ::Union{Nothing, Jj2lsjCmd.Jj2lsj},
            rlevels                  ::Union{Nothing, RlevelsCmd.Rlevels}
    )
    if  rangular     == nothing  rangular= RangularCmd.Rangular(default=default);  end
    if  rcsfinteract == nothing  rcsfinteract= RcsfinteractCmd.Rcsfinteract(default=default);    end
    if  rwfnestimate == nothing  rwfnestimate= RwfnestimateCmd.Rwfnestimate(default=default, radial_wavefunctions=default.radial_wavefunctions);  end
    if  rmcdhf       == nothing  rmcdhf= RmcdhfCmd.Rmcdhf(default=default);  end
    if  rci          == nothing  rci=RciCmd.Rci(default=default, n_max= default.n_max);  end
    if  jj2lsj       == nothing  jj2lsj= Jj2lsjCmd.Jj2lsj(default=default);  end
    if  rlevels      == nothing  rlevels= RlevelsCmd.Rlevels(default=default);  end

        Calc(
            default       = default,
            rnucleus      = rnucleus,
            rcsfgenerate  = rcsfgenerate,
            rangular      = rangular,
            rcsfinteract  = rcsfinteract,
            rwfnestimate  = rwfnestimate,
            rmcdhf        = rmcdhf,
            rci           = rci,
            jj2lsj        = jj2lsj,
            rlevels       = rlevels
    )

    end

    function Execute(calc::Calc)
        state_folder = calc.default.state_folder
        Base.cd(state_folder)

        Basics.Execute(calc.rnucleus)
        Basics.Execute(calc.rcsfgenerate)
        Basics.Execute(calc.rangular)
        Basics.Execute(calc.rcsfinteract)
        Basics.Execute(calc.rwfnestimate)
        Basics.Execute(calc.rmcdhf)
        Basics.Execute(calc.rci)
        Basics.Execute(calc.jj2lsj)
        Basics.Execute(calc.rlevels)
        println("\n\n\n========================================== Calc Finished ========================================================")
    end
end