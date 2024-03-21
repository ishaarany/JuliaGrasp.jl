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
        state = getRSaveFileName(rci);
        include_H                = rci.include_H;
        modify_freq              = rci.modify_freq;
        include_vac_polr         = rci.include_vac_polr;
        include_norm_mass_shift  = rci.include_norm_mass_shift;
        include_spc_mass_shift   = rci.include_spc_mass_shift;
        estimate_self_energy     = rci.estimate_self_energy;
        n_max                    = rci.n_max;
        println(io, "\t Name of state                            :\t"*state*"\n")
        println(io, "\t Include contribution of H (Transverse)   :\t"*include_H*"\n")
        println(io, "\t Modify all transverse photon frequencies :\t"*modify_freq*"\n")
        println(io, "\t Include H (Vacuum Polarisation)          :\t"*include_vac_polr*"\n")
        println(io, "\t Include H (Normal Mass Shift)            :\t"*include_norm_mass_shift*"\n")
        println(io, "\t Include H (Specific Mass Shift)          :\t"*include_spc_mass_shift*"\n")
        println(io, "\t Estimate self-energy?                    :\t"*estimate_self_energy*"\n")
        println(io, "\t Largest n quantum number                 :\t"*string(n_max)*"\n")
    end

    function WriteRciInput(rci::Rci)
        input_dir = rci.default.in_folder
        Base.cd(input_dir);
        filepath= joinpath(input_dir,"rci.inp")
        state = getRSaveFileName(rci);
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

    function getRSaveFileName(m::Rci)
        # rsave = m.default.state*string(m.default.principle_orbital-1);
        # rsaveMr = "mr";
        # rsaveW =rsave*".w";
        # rsaveMrW =rsaveMr*".w";
        # if isfile(rsaveW)
        #     return rsave
        # elseif  isfile(rsaveMrW)
        #     return rsaveMr
        # else
        #     return m.default.state*string(m.default.principle_orbital);
        # end
        rsavefilename=""
        filepath = joinpath(m.default.state_folder, "rsavename.txt")
        if isfile(filepath)
            io = open(filepath,"r")
            rsavefilename= read(io);
            close(io)
        else
            error("file rsavename.txt not found")
        end
        return rsavefilename
    end

    function Basics.Execute(rci::Rci)
        state_folder = rci.default.state_folder
        Base.cd(state_folder)
        state = getRSaveFileName(rci);
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