"""
`module  JuliaGrasp.RangularCmd`  
    ... a submodel of JuliaGRASP that use to run GRASP commands: RangularCmd .
"""
module RangularCmd

    using ..Basics, FieldDefaults, ..DefaultModule

    export Execute, Rangular

    abstract type AbstractRangular  end

    @default_kw mutable struct  Rangular <: AbstractRangular
        default  ::DefaultModule.Default
    end
    
    function Base.getproperty(m::Rangular, s::String)
        Base.getproperty(m, Symbol(s))        
    end

    function Basics.Execute(rangular::Rangular)
        state_folder = rangular.default.state_folder
        Base.cd(state_folder)

        open(`rangular`, "w", Base.stdout) do io
            println(io, "y");
        end
        println("================================= Angular Calc Finished======================================")
    end
end