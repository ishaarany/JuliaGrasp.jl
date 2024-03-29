"""
`module  JuliaGrasp.RcsfzerofirstCmd`  
    ... a submodel of JuliaGRASP that use to run GRASP commands: RcsfzerofirstCmd.
"""
module RcsfzerofirstCmd

    using ..Basics, FieldDefaults, ..DefaultModule

    export Execute, Rcsfzerofirst

    abstract type AbstractRcsfzerofirst  end

    @default_kw mutable struct  Rcsfzerofirst <: AbstractRcsfzerofirst
        default  ::DefaultModule.Default
    end

    function Basics.Execute(rcsfzerofirst::Rcsfzerofirst)
  
        open(`rcsfzerofirst`, "w", Base.stdout) do io
            println(io, "mr.c");
            println(io, "rcsf.inp");
        end

        Base.cp("rcsf.out", "rcsf.inp",force=true)
        
        println("================================= rcsfzerofirst command executed succefully======================================")

    end
end