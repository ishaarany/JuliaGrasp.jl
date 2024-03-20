"""
`module  JuliaGrasp.RcsfinteractCmd`  
    ... a submodel of JuliaGRASP that use to run GRASP commands: RcsfinteractCmd .
"""
module RcsfinteractCmd

    using ..Basics, FieldDefaults, ..DefaultModule

    export Execute, Rcsfinteract

    abstract type AbstractRcsfinteract  end

    @default_kw mutable struct  Rcsfinteract <: AbstractRcsfinteract
        default  ::DefaultModule.Default
    end
    
    function Base.getproperty(m::Rcsfinteract, s::String)
        Base.getproperty(m, Symbol(s))        
    end

    function Basics.Execute(rcsfinteract::Rcsfinteract)
        calc_dir = rcsfinteract.default.state_folder
        Base.cd(calc_dir)

        in_folder = rcsfinteract.default.in_folder
        in_file = joinpath(in_folder,"rcsfinteract.in")

        out_folder = rcsfinteract.default.out_folder
        out_file = joinpath(out_folder,"rcsfinteract.out")

        io= open(in_file, "w")
        println(io,"1")
        close(io)

        run(pipeline(in_file,`rcsfinteract`, out_file))
        lines= ReadFileLines(out_file)

        for line in lines
            println(line*"\n")
        end

        Base.rm(in_file, force=true)

        # open(`rcsfinteract`, "w", Base.stdout) do io
        #     println(io, "2");
        # end

        Base.cp("rcsf.out", "rcsf.inp", force=true)
        println("================================= Rcsfinteract Calc Finished ======================================")
    end
end