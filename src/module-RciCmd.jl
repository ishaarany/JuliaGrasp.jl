"""
`module  JuliaGrasp.RciCmd`  
    ... a submodel of JuliaGRASP that use to run GRASP commands: RciCmd .
"""
module RciCmd

    using ..Basics, FieldDefaults, ..DefaultModule

    export Execute, Rci

    abstract type AbstractRci  end
            
    """
    `struct Rci <: AbstractRci`                                          ... defines a type for rci.
    +  default                      ::DefaultModule.Default              ... default
    + include_H                     ::String                             ... Include contribution of H (Transverse)
    + modify_freq                   ::String                             ... Modify all transverse photon frequencies
    + include_vac_polr              ::String                             ... Include H (Vacuum Polarisation)
    + include_norm_mass_shift       ::String                             ... Include H (Normal Mass Shift)
    + include_spc_mass_shift        ::String                             ... Include H (Specific Mass Shift)
    + estimate_self_energy          ::String                             ... Estimate self-energy?
    + n_max                         ::String                             ... Largest n quantum number n should be less or equal 8
    
    """
    @default_kw mutable struct  Rci <: AbstractRci
        default                       ::DefaultModule.Default
        include_H                     ::String|"y"
        modify_freq                   ::String|"n"
        include_vac_polr              ::String|"y"
        include_norm_mass_shift       ::String|"n"
        include_spc_mass_shift        ::String|"n"
        estimate_self_energy          ::String|"y"
        n_max                         ::Int64        
    end
    
    function Base.getproperty(m::Rci, s::String)
        Base.getproperty(m, Symbol(s))        
    end

    function Base.show(io::IO, rci::Rci)
        state                    = rci.default.state;
        include_H                = rci.include_H;
        modify_freq              = rci.modify_freq;
        include_vac_polr         = rci.include_vac_polr;
        include_norm_mass_shift  = rci.include_norm_mass_shift;
        include_spc_mass_shift   = rci.include_spc_mass_shift;
        estimate_self_energy     = rci.estimate_self_energy;
        n_max                    = rci.n_max;
        println(io, "\tName of state                            : "*state*"\n")
        println(io, "\tInclude contribution of H (Transverse)   : "*include_H*"\n")
        println(io, "\tModify all transverse photon frequencies : "*modify_freq*"\n")
        println(io, "\tInclude H (Vacuum Polarisation)          : "*include_vac_polr*"\n")
        println(io, "\tInclude H (Normal Mass Shift)            : "*include_norm_mass_shift*"\n")
        println(io, "\tInclude H (Specific Mass Shift)          : "*include_spc_mass_shift*"\n")
        println(io, "\tEstimate self-energy?                    : "*estimate_self_energy*"\n")
        println(io, "\tLargest n quantum number                 : "*string(n_max)*"\n")
    end

    function WriteRciInput(rci::Rci)
        input_dir = rci.default.in_folder
        Base.cd(input_dir);
        filepath= joinpath(input_dir,"rci.inp")
        state                    = rci.default.state;
        include_H                = rci.include_H;
        modify_freq              = rci.modify_freq;
        include_vac_polr         = rci.include_vac_polr;
        include_norm_mass_shift  = rci.include_norm_mass_shift;
        include_spc_mass_shift   = rci.include_spc_mass_shift;
        estimate_self_energy     = rci.estimate_self_energy;
        n_max                    = rci.n_max;

        lines=Basics.GetBlocks(rci.default.principle_orbital, rci.default.state_folder)

        open(filepath, "w") do io
            println(io, "y");
            println(io, state)
            println(io, include_H)
            println(io, modify_freq)
            println(io, include_vac_polr)
            println(io, include_norm_mass_shift)
            println(io, include_spc_mass_shift)
            println(io, estimate_self_energy)
            println(io, n_max)
            for line in lines
                println(io, line);
            end
        end
        state_folder= rci.default.state_folder
        Base.cd(state_folder)
    end


    function Basics.Execute(rci::Rci)
        state_folder = rci.default.state_folder
        Base.cd(state_folder)
        state                    = rci.default.state;
        include_H                = rci.include_H;
        modify_freq              = rci.modify_freq;
        include_vac_polr         = rci.include_vac_polr;
        include_norm_mass_shift  = rci.include_norm_mass_shift;
        include_spc_mass_shift   = rci.include_spc_mass_shift;
        estimate_self_energy     = rci.estimate_self_energy;
        n_max                    = rci.n_max;
        
        lines=Basics.GetBlocks(rci.default.principle_orbital, rci.default.state_folder)

        open(`rci`, "w", Base.stdout) do io
            println(io, "y");
            println(io, state)
            println(io, include_H)
            println(io, modify_freq)
            println(io, include_vac_polr)
            println(io, include_norm_mass_shift)
            println(io, include_spc_mass_shift)
            println(io, estimate_self_energy)
            println(io, n_max)
            for line in lines
                println(io, line);
            end
        end

        WriteRciInput(rci)
        println("================================= Rci Calc Finished ======================================")
    end
end