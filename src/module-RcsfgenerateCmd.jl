"""
`module  JuliaGrasp.RcsfgenerateCmd`  
    ... a submodel of JuliaGRASP that use to run GRASP commands: RcsfgenerateCmd .
"""
module RcsfgenerateCmd

    using ..Basics, FieldDefaults, ..DefaultModule

    export Rcsfgenerate, Configurations, Execute

    abstract type AbstractCsfgenerate     end
    abstract type AbstractConfigurations  end

    coredic = Dict("None"=>0,"He"=>1,"Ne"=>2,"Ar"=>3,"Kr"=>4,"Xe"=>5,"Rn"=>6)
    
    """
    `struct Configurations <: AbstractConfigurations`   ... defines a type for Configurations.
        + core         ::String                          ... define core(eg. He, Ne,...)
        + Configs      ::Vector{String}                  ...  Configuration list.
    """
    @default_kw mutable struct Configurations
        core          ::String 
        Configs       ::Vector{String}|[]
    end 

    """
    `struct Rcsfgenerate <: AbstractCsfgenerate`            ... defines a type for Rcsfgenerate.
        + default         ::DefaultModule.Default           ... default
        + Configs         ::Configurations                  ... Configurations.
        + stop            ::String                          ... to stop adding Configuration
        + Jl              ::Int64|0                         ... 2*J-number? lower  (2*J=1 etc.)
        + Jh              ::Int64|0                         ... 2*J-number? higher (2*J=2 etc.)
        + noex            ::Int64|0                         ... Number of excitations (0,2,-2)
        + active_orbitals ::String                          ... Set of active orbitals e.g. (3s,3p,3d)
    """
    @default_kw mutable struct Rcsfgenerate <: AbstractCsfgenerate
        default              ::DefaultModule.Default
        Configs              ::Configurations
        Jl                   ::Int64|0
        Jh                   ::Int64|0
        noex                 ::Int64|0
        active_orbitals      ::String
    end

    function GetCore(configs::Configurations)
        core = configs.core
        !Base.haskey(coredic, String(core)) && error("Configurations have no core= $core")
        core
    end

    function Base.show(io::IO, configs::Configurations)
        core = GetCore(configs)
        Configurations = configs.Configs
        println(io, "Core   : "*core*"\n")
        println(io, "Configs:\n")
        for config in Configurations
            println(io, config*"\n")
        end
    end

    function Base.show(io::IO, rcsfgenerate::Rcsfgenerate)
       Configurations= DestructConfigurations(rcsfgenerate);
       show(io, Configurations)
       Jl=rcsfgenerate.Jl
       Jh=rcsfgenerate.Jh
       noex= rcsfgenerate.noex;
       Jhl= string(Jl)*","*string(Jh);
       Aset=GetActiveOrbits(rcsfgenerate)
       println(io, "\n\tActive set orbits : " * string(Aset)*"\n");
       println(io, "\tHigher 2*J          : " * string(Jh)*"\n");
       println(io, "\tLower 2*J           : " * string(Jl)*"\n");
       println(io, "\texcitations         : " * string(noex)*"\n");
    end

    function DestructConfigurations(rcsfgenerate::Rcsfgenerate)
        rcsfgenerate.Configs
    end

    function GetActiveOrbits(rcsfgenerate::Rcsfgenerate)
        rcsfgenerate.active_orbitals
    end

    function GetCore(rcsfgenerate::Rcsfgenerate)
        configurations = DestructConfigurations(rcsfgenerate)
        core  = configurations.core
        !Base.haskey(coredic, String(core)) && error("Configurations have no core= $core")
        coredic[core]
    end

    function GetConfigurations(rcsfgenerate::Rcsfgenerate)
        configurations = DestructConfigurations(rcsfgenerate)
        configurations.Configs
    end

    # `Base.unique(confs::Array{Configuration,1})`  ... return a unique list of configurations.
    function Base.unique(confs::Array{Configurations,1})
        confList       = Configuration[]  
        configurations = deepcopy(confs)
        for  confa in configurations
            addTo = true
            for confb in confList    if   confa == confb    addTo = false;    break     end     end
            if  addTo    push!(confList, confa)     end
        end
    
        return( confList )
    end


    function WriteRcsfgenerateInput(rcsfgenerate::Rcsfgenerate)
        input_dir = rcsfgenerate.default.in_folder
        Base.cd(input_dir);
        filepath= joinpath(input_dir,"rcsfgenerate.inp")
        # Base.mkpath(filepath) # create
        io = open(filepath,"w")
        core = GetCore(rcsfgenerate);
        configs = GetConfigurations(rcsfgenerate);
        Jl=rcsfgenerate.Jl
        Jh=rcsfgenerate.Jh
        noex= rcsfgenerate.noex
        Jhl= string(Jl)*","*string(Jh);
        Aset=GetActiveOrbits(rcsfgenerate)
        write(io, "*\n"); # Default
        write(io, string(core)*"\n");
        for val in configs
            write(io, string(val)*"\n");
        end
        write(io, "*\n"); # stop entering configs
        write(io, string(Aset)*"\n");
        write(io, string(Jhl)*"\n");
        write(io, string(noex)*"\n"); # Number of excitations
        write(io, "n\n");
        close(io)
        return filepath
    end


    function Basics.Execute(rcsfgenerate::Rcsfgenerate)
        state_folder = rcsfgenerate.default.state_folder;
        mr_folder = rcsfgenerate.default.mr_folder;
        
        filepath=WriteRcsfgenerateInput(rcsfgenerate)
        !Base.isfile(joinpath(state_folder,"isodata")) && error("No isodata file exists, you should run Rnucleus command first")
        Base.cd(state_folder);
        noex= rcsfgenerate.noex
        out_folder = rcsfgenerate.default.out_folder
        outRcsfgenerateFilepath = joinpath(out_folder,"rcsfgenerate.out")

        run(pipeline(filepath,`rcsfgenerate`, out_file))

        CreateBlocksFile(outRcsfgenerateFilepath, out_folder, mr_folder)
        # GetNoCSF( state_folder, out_file)
        Base.cp("rcsf.out", "rcsf.inp",force=true)
        (noex == 0) && Base.cp("rcsf.out", "rcsfmr.inp", force=true)
        lines= ReadFileLines(out_file)
        for line in lines
            println(line*"\n")
        end
        println("================ CSF NO =================\n")
        noCsf= GetNoCSF(out_folder::String)
        println("\t\t"*noCsf*"\n")
        println("================================= Rcsfgenerate Calc Finished ======================================")
    end
    
    function GetNoCSF(out_folder::String)
        CSFfilepath = joinpath(out_folder, "CSF.txt")
        lines= Basics.ReadFileLines(CSFfilepath)
        lines[1];
    end

    function CreateBlocksFile(outRcsfgenerateFilepath::String, out_folder::String, mr_folder::String)
        lines= Basics.ReadFileLines(outRcsfgenerateFilepath)
        sStart="       block  J/P            NCSF"
        i=Basics.FindStringIndexInVector(sStart, lines)
        blockfilepath = joinpath(mr_folder, "blocks.txt")

        io = open(blockfilepath,"w")

        blocks= lines[i+1:end]
        # println("Blocks:")
        csf = 0
        for line in blocks
            cols = Base.split(Base.strip(line)," ")
            write(io,"1-"*cols[end]*"\n");
            csf+=parse(Int64,string(cols[end]))
            # println("       1, "*cols[end]*"\n");
        end
        close(io)
        #  write CSF file
        CSFfilepath = joinpath(out_folder, "CSF.txt")
        csfio = open(CSFfilepath,"w")
        write(csfio,string(csf)*"\n");
        close(csfio)
        # println("Blocks file created with")
        close(io)
    end
end