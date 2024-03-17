"""
`module  JuliaGrasp.Jj2lsjCmd`  
    ... a submodel of JuliaGRASP that use to run GRASP commands: Jj2lsjCmd .
"""
module Jj2lsjCmd

    using ..Basics, FieldDefaults, ..DefaultModule

    export Execute, Jj2lsj

    abstract type AbstractJj2lsj  end
            
    """
    `struct Jj2lsj <: AbstractJj2lsj`                                    ... defines a type for Rmcdhf.
    + default                           ::DefaultModule.Default          ... default
    + mixing_coefficients               ::String                         ... Mixing coefficients from a CI calc
    + unique_labeling                   ::String                         ... Do you need a unique unique_labeling

    """
    @default_kw mutable struct  Jj2lsj <: AbstractJj2lsj
        default                       ::DefaultModule.Default
        mixing_coefficients           ::String|"y"
        unique_labeling               ::String|"y"
    end
    
    function Base.getproperty(m::Jj2lsj, s::String)
        Base.getproperty(m, Symbol(s))        
    end

    function Base.show(io::IO, jj2lsj::Jj2lsj)
        state = getRSaveFileName(jj2lsj);
        mixing_coefficients           = jj2lsj.mixing_coefficients;
        unique_labeling               = jj2lsj.unique_labeling;

        println(io, "\t Name of state                            :\t"*state*"\n")
        println(io, "\t Mixing coefficients from a CI calc       :\t"*mixing_coefficients*"\n")
        println(io, "\t Unique labeling                          :\t"*unique_labeling*"\n")

    end

    function getRSaveFileName(m::Jj2lsj)
        rsave = m.default.state*string(m.default.principle_orbital-1);
        if isfile(rsave)
            return  rsave
        else
            return m.default.state*string(m.default.principle_orbital);
        end
    end

    function WriteJj2lsjInput(jj2lsj::Jj2lsj)
        input_dir = jj2lsj.default.in_folder
        Base.cd(input_dir);
        filepath= joinpath(input_dir,"jj2lsj.inp")
        state = getRSaveFileName(jj2lsj);
        mixing_coefficients  = jj2lsj.mixing_coefficients;
        unique_labeling      = jj2lsj.unique_labeling;

        open(filepath, "w") do io
            println(io, state)
            println(io, mixing_coefficients)
            println(io, unique_labeling)
            println(io, "y");
        end
        state_folder= jj2lsj.default.state_folder
        Base.cd(state_folder)
    end

    function Basics.Execute(jj2lsj::Jj2lsj)
        state_folder= jj2lsj.default.state_folder
        Base.cd(state_folder)
        state = getRSaveFileName(jj2lsj);
        mixing_coefficients                = jj2lsj.mixing_coefficients;
        unique_labeling                    = jj2lsj.unique_labeling;

        open(`jj2lsj`, "w", Base.stdout) do io
            println(io, state)
            println(io, mixing_coefficients)
            println(io, unique_labeling)
            println(io, "y");
        end
        WriteJj2lsjInput(jj2lsj)
        println("================================= Jj2lsj Calc Finished ======================================")
    end
end