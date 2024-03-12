"""
`module  JuliaGrasp.Default`  
    ... a submodel of JuliaGRASP to initialize calculations.
"""
module DefaultModule

    using ..Basics, FieldDefaults

    export Default

    abstract type AbstractDefault  end

    """
    `struct Default <: AbstractDefault`                ... defines a type for Default.
    + calc_dir                      ::String           ... working directory path
    + state                         ::String           ... Name of state
    """
    @default_kw mutable struct Default <: AbstractDefault
        calc_dir                      ::String
        state                         ::String|"even"
        principle_orbital             ::Int64|3
        state_folder                  ::String|""
        out_folder                    ::String|"out"
        in_folder                     ::String|"in"
        radial_wavefunctions          ::Int64|2
        n_max                         ::Int64|4
    end

    
    function Base.show(io::IO, default::Default)
        calc_dir             = default.calc_dir
        state                = default.state
        principle_orbital    = default.principle_orbital
        state_folder         = default.state_folder
        out_folder           = default.out_folder
        in_folder            = default.in_folder
        radial_wavefunctions = default.radial_wavefunctions
        n_max                = default.n_max

        println(io, "\tcalc_dir            :\t"*calc_dir*"\n")
        println(io, "\tstate                 :\t"*state*"\n")
        println(io, "\tprinciple_orbital     :\t"*string(principle_orbital)*"\n")
        println(io, "\tstate_folder          :\t"*state_folder*"\n")
        println(io, "\tout_folder            :\t"*out_folder*"\n")
        println(io, "\tin_folder             :\t"*in_folder*"\n")
        println(io, "\tradial_wavefunctions  :\t"*string(radial_wavefunctions)*"\n")
        println(io, "\tn_max                 :\t"*string(n_max)*"\n")

    end

    """
        Create required folders if not exist
    """
    function Init(default::Default)
        # create main folder
        ! isdir(default.calc_dir) &&  Base.mkpath(default.calc_dir)

        # create state folder
        state_folder = joinpath(default.calc_dir, default.state)
        ! isdir(state_folder) &&  Base.mkpath(state_folder) 
        default.state_folder = state_folder

        # create in folder
        in_folder = joinpath(state_folder, "n"*string(default.principle_orbital), default.in_folder,"input")
        ! isdir(in_folder) &&  Base.mkpath(in_folder)
        default.in_folder = in_folder

        # create out folder
        out_folder = joinpath(state_folder, "n"*string(default.principle_orbital), default.out_folder,"output")
        ! isdir(out_folder) &&  Base.mkpath(out_folder)
        default.out_folder = out_folder

        return default
    end

end