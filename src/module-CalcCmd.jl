"""
`module  JuliaGrasp.CalcCmd`  
    ... a submodel of JuliaGRASP that use to run GRASP commands:
                                                    Rnucleus
                                                    Rcsfgenerate
                                                    Rangular
                                                    Rcsfinteract
                                                    Rwfnestimate
                                                    Rmcdhf
                                                    Rsave
                                                    Rci
                                                    Jj2lsj
                                                    Rlevels
    in one shot
"""
module CalcCmd

    using ..Basics, ..DefaultModule, FieldDefaults,..RnucleusCmd, 
    ..RcsfgenerateCmd, ..RangularCmd, ..RcsfinteractCmd, ..RwfnestimateCmd, 
    ..RmcdhfCmd, ..RsaveCmd, ..RciCmd, ..Jj2lsjCmd, ..RlevelsCmd

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
        rsave                    ::RsaveCmd.Rsave
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
            rsave                    ::Union{Nothing, RsaveCmd.Rsave},
            rci                      ::Union{Nothing, RciCmd.Rci},
            jj2lsj                   ::Union{Nothing, Jj2lsjCmd.Jj2lsj},
            rlevels                  ::Union{Nothing, RlevelsCmd.Rlevels}
    )
    if  rangular     == nothing  rangular= RangularCmd.Rangular(default=default);  end
    if  rcsfinteract == nothing  rcsfinteract= RcsfinteractCmd.Rcsfinteract(default=default);    end
    if  rwfnestimate == nothing  rwfnestimate= RwfnestimateCmd.Rwfnestimate(default=default, radial_wavefunctions=default.radial_wavefunctions);  end
    if  rmcdhf       == nothing  rmcdhf= RmcdhfCmd.Rmcdhf(default=default);  end
    if  rsave        == nothing  rsave= RsaveCmd.Rsave(default=default);  end
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
            rsave         = rsave,
            rci           = rci,
            jj2lsj        = jj2lsj,
            rlevels       = rlevels
    )

    end

    function Execute(calc::Calc)
        state_folder = calc.default.state_folder
        Base.cd(state_folder)

        @sync begin
            Basics.Execute(calc.rnucleus)

            rcsfgenerate = Condition()
            @async begin
                Basics.Execute(calc.rcsfgenerate)
                notify(rcsfgenerate)
            end
        

            rangular = Condition()
            @async begin
                wait(rcsfgenerate)
                Basics.Execute(calc.rangular)
                notify(rangular)
            end
        

            rcsfinteract = Condition()
            @async begin
                wait(rangular)
                Basics.Execute(calc.rcsfinteract)
                notify(rcsfinteract)
            end
        

            rwfnestimate = Condition()
            @async begin
                wait(rcsfinteract)
                Basics.Execute(calc.rwfnestimate)
                notify(rwfnestimate)
            end
        

            rmcdhf = Condition()
            @async begin
                wait(rwfnestimate)
                Basics.Execute(calc.rmcdhf)
                notify(rmcdhf)
            end

            rsave = Condition()
            @async begin
                wait(rmcdhf)
                Basics.Execute(calc.rsave)
                notify(rsave)
            end
        

            rci = Condition()
            @async begin
                wait(rsave)
                Basics.Execute(calc.rci)
                notify(rci)
            end

        

            jj2lsj = Condition()
            @async begin
                wait(rci)
                Basics.Execute(calc.jj2lsj)
                notify(jj2lsj)
            end

        
            @async begin
                wait(jj2lsj)
                Basics.Execute(calc.rlevels)
            end
        end

        println("\n\n\n========================================== Calc Finished ========================================================")
    end
end