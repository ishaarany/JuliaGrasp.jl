"""
`module  JuliaGrasp.RlevelsCmd`  
    ... a submodel of JuliaGRASP that use to run GRASP commands: RlevelsCmd .
"""
module RlevelsCmd

    using ..Basics, FieldDefaults, ..DefaultModule

    export Execute, Rlevels

    abstract type AbstractRlevels  end
            
    """
        `struct Jj2lsj <: AbstractJj2lsj`                                    ... defines a type for Rmcdhf.
        + default               ::DefaultModule.Default                      ... default
    """

    @default_kw mutable struct  Rlevels <: AbstractRlevels
        default               ::DefaultModule.Default
    end


    function Base.show(io::IO, rlevels::Rlevels)
        state = getRSaveFileName(rlevels)
        println(io, "Name of state: "*state*"\n")

    end

    function getRSaveFileName(m::Rlevels)
        rsavefilename=""
        filepath = joinpath(m.default.state_folder, "rsavename.txt")
        if isfile(filepath)
            lines= Basics.ReadFileLines(filepath)
            rsavefilename= lines[1]
        else
            error("file rsavename.txt not found")
        end

        println("rsavefilename: $rsavefilename")
        return rsavefilename
    end

    function Basics.Execute(rlevels::Rlevels)
        state_folder = rlevels.default.state_folder
        state= getRSaveFileName(rlevels)*".cm";

        out_dir = rlevels.default.out_folder
        out_file = joinpath(out_dir, "rlevels.out")
        Base.cd(state_folder)

        run(pipeline(`rlevels $state`, out_file))

        lines = Basics.ReadFileLines(out_file)
        for line in lines
            println(line)
        end

        Base.cd(state_folder)

        println("================================= Rlevels Calc Finished ======================================")
    end
end