"""
`module  JuliaGrasp.RmcdhfCmd`  
    ... a submodel of JuliaGRASP that use to run GRASP commands: RmcdhfCmd .
"""
module RmcdhfCmd

    using ..Basics, FieldDefaults, ..DefaultModule

    export Execute, Rmcdhf

    abstract type AbstractRmcdhf  end

        
    """
    `struct Rmcdhf <: AbstractRmcdhf`                                 ... defines a type for Rmcdhf.
        + default                   ::DefaultModule.Default           ... default
        + level_weights             ::String                          ... level weights (1 equal; 5 standard; 9 user)
        + var_orbits                ::String                          ... Enter orbitals to be varied (Updating order)
        + spect_orbits              ::String                          ... Enter spectroscopic orbitals
        + cycles                    ::Int64                           ... Enter the maximum number of SCF cycles

    """

    @default_kw mutable struct  Rmcdhf <: AbstractRmcdhf
        default              ::DefaultModule.Default
        level_weights        ::Int64|5
        var_orbits           ::String|"*"
        spect_orbits         ::String|"*"
    end


    function Base.show(io::IO, rmcdhf::Rmcdhf)
        state           = rmcdhf.default.state;
        level_weights   = rmcdhf.level_weights;
        var_orbits      = rmcdhf.default.var_orbits;
        spect_orbits    = rmcdhf.default.spect_orbits;
        cycles          = rmcdhf.default.cycles;

        println(io, "rsave file name              : "*state*"\n")
        println(io, "level weights                : "*string(level_weights)*"\n")
        println(io, "varied orbitals              : "*var_orbits*"\n")
        println(io, "spectroscopic orbitals       : "*spect_orbits*"\n")
        println(io, "maximum number of SCF cycles : "*string(cycles)*"\n")
    end

    function WriteRmcdhfInput(rmcdhf::Rmcdhf)
        input_dir       = rmcdhf.default.in_folder
        filepath        = joinpath(input_dir,"rmcdhf.inp")

        level_weights   = rmcdhf.level_weights;
        var_orbits      = rmcdhf.default.var_orbits;
        spect_orbits    = rmcdhf.default.spect_orbits;
        cycles          = rmcdhf.default.cycles;

        lines=Basics.GetBlocks(rmcdhf.default.principle_orbital, rmcdhf.default.state_folder)
        io = open(filepath,"w")
        write(io, "y\n"); # Default
        for line in lines
            write(io, string(line)*"\n");
        end

        write(io, string(level_weights)*"\n");
        write(io, string(var_orbits)*"\n");
        write(io, string(spect_orbits)*"\n");
        write(io, string(cycles)*"\n");
        close(io)
        Base.cd(rmcdhf.default.state_folder)
    end

    function Basics.Execute(rmcdhf::Rmcdhf)
        state_folder    = rmcdhf.default.state_folder
        level_weights   = rmcdhf.level_weights;
        var_orbits      = rmcdhf.default.var_orbits;
        spect_orbits    = rmcdhf.default.spect_orbits;
        cycles          = rmcdhf.default.cycles;

        lines=Basics.GetBlocks(rmcdhf.default.principle_orbital, rmcdhf.default.state_folder)

        Base.cd(state_folder)
        open(`rmcdhf`,"w", Base.stdout) do io
            println(io, "y");            #  use Default
            for line in lines
                println(io, line);
            end
            println(io, level_weights);
            println(io, var_orbits);
            println(io, spect_orbits);
            println(io, cycles);

        end

        state = rmcdhf.default.state;

        out_dir = rmcdhf.default.out_folder
        out_file = joinpath(out_dir, "rsave.out")

        filepath=WriteRmcdhfInput(rmcdhf::Rmcdhf)
        
        run(pipeline(`rsave $state`, out_file))

        # open(`rsave $state`,"w", Base.stdout) do io
        println("===================================")
        println(" rsave command executed succefully")
        println("===================================")
        # end
        # io = open(filepath,"w")
        # run(pipeline(filepath,`rmcdhf`, Base.stdout))
        println("================================= Rmcdhf Calc Finished ======================================")
    end
end