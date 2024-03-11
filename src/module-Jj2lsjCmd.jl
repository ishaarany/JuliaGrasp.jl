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
        state                         = jj2lsj.default.state;
        mixing_coefficients           = jj2lsj.mixing_coefficients;
        unique_labeling               = jj2lsj.unique_labeling;

        println(io, "\tName of state                            : "*state*"\n")
        println(io, "\tMixing coefficients from a CI calc       : "*mixing_coefficients*"\n")
        println(io, "\tUnique labeling                          : "*unique_labeling*"\n")

    end

    function GetBlocks(dir::String)
        blockfilepath = joinpath(dir, "blocks.txt")
        Basics.ReadFileLines(blockfilepath)
    end

    function Basics.Execute(jj2lsj::Jj2lsj)
        state_folder= jj2lsj.default.state_folder
        Base.cd(state_folder)
        state                              = jj2lsj.default.state;
        mixing_coefficients                = jj2lsj.mixing_coefficients;
        unique_labeling                    = jj2lsj.unique_labeling;

        open(`jj2lsj`, "w", Base.stdout) do io
            println(io, state)
            println(io, mixing_coefficients)
            println(io, unique_labeling)
            println(io, "y");
        end
        println("================================= Jj2lsj Calc Finished======================================")
    end
end