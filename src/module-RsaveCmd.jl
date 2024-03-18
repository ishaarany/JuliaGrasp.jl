"""
`module  JuliaGrasp.RsaveCmd`  
    ... a submodel of JuliaGRASP that use to run GRASP commands: RsaveCmd.
"""
module RsaveCmd

    using ..Basics, FieldDefaults, ..DefaultModule

    export Execute, Rsave

    abstract type AbstractRsave  end

    @default_kw mutable struct  Rsave <: AbstractRsave
        default  ::DefaultModule.Default
    end

    function Basics.Execute(rsave::Rsave)
        if(rsave.default.excitations == 0)
            state = "mr"
        else
            state = rsave.default.state*string(rsave.default.principle_orbital);
        end

        # out_file = joinpath(state_folder, "rsave.out")   
        run(`rsave $state`)
        
        println("================================= rsave command executed succefully======================================")

    end
end