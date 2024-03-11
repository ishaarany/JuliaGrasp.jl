"""
`module  JuliaGrasp.RcsfgenerateCmd`  
    ... a submodel of JuliaGRASP that use to run GRASP commands: RcsfgenerateCmd .
"""
module RcsfgenerateCmd

    using ..Basics, FieldDefaults

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
        + calc_dir        ::String                          ... working directory path
        + Configs         ::Configurations                  ... Configurations.
        + stop            ::String                          ... to stop adding Configuration
        + Jl              ::Int64|0                         ... 2*J-number? lower  (2*J=1 etc.)
        + Jh              ::Int64|0                         ... 2*J-number? higher (2*J=2 etc.)
        + noex            ::Int64|0                         ... Number of excitations (0,1,2,-2)
        + active_orbitals ::String                          ... Set of active orbitals e.g. (3s,3p,3d)
    """
    @default_kw mutable struct Rcsfgenerate <: AbstractCsfgenerate
        calc_dir             ::String
        Configs              ::Configurations
        Jl                   ::Int64|0
        Jh                   ::Int64|0
        noex                 ::Int64|0
        active_orbitals      ::String
    end
    
    function Base.getproperty(m::Rcsfgenerate, s::String)
        Base.getproperty(m, Symbol(s))        
    end

    function Base.getproperty(c::Configurations, s::String)
        Base.getproperty(c, Symbol(s))        
    end

    function GetCore(configs::Configurations)
        core = getproperty(configs,"core")
        !Base.haskey(coredic, String(core)) && error("Configurations have no core= $core")
        coredic[core]
    end

    function Base.show(io::IO, configs::Configurations)
        core = GetCore(configs)
        Configurations = getproperty(configs,"Configs")
        println(io, "core: "*core*"\n")
        for config in Configurations
            println(io, config*"\n")
        end
    end

    function Base.show(io::IO, rcsfgenerate::Rcsfgenerate)
       Configurations= GetConfigurations(rcsfgenerate);
       show(io, Configurations)
       Jl= GetJl(rcsfgenerate);
       Jh= GetJh(rcsfgenerate);
       noex= Getnoex(rcsfgenerate);
       Jhl= string(Jl)*","*string(Jh);
       Aset=GetActiveOrbits(rcsfgenerate)
       println(io, "Active set orbits:" * string(Aset)*"\n");
       println(io, "Higher 2*J       :" * string(Jh)*"\n");
       println(io, "Lower 2*J        :" * string(Jl)*"\n");
       println(io, "excitations      :" * string(noex)*"\n");
    end

    function DestructConfigurations(rcsfgenerate::Rcsfgenerate)
        getproperty(rcsfgenerate,"Configs")
    end

    function Getnoex(rcsfgenerate::Rcsfgenerate)
        getproperty(rcsfgenerate,"noex")
    end

    function GetJl(rcsfgenerate::Rcsfgenerate)
        getproperty(rcsfgenerate,"Jl")
    end

    function GetJh(rcsfgenerate::Rcsfgenerate)
        getproperty(rcsfgenerate,"Jh")
    end

    function GetActiveOrbits(rcsfgenerate::Rcsfgenerate)
        getproperty(rcsfgenerate,"active_orbitals")
    end

    function GetCore(rcsfgenerate::Rcsfgenerate)
        configurations = DestructConfigurations(rcsfgenerate)
        core  = getproperty(configurations, "core")
        !Base.haskey(coredic, String(core)) && error("Configurations have no core= $core")
        coredic[core]
    end

    function GetConfigurations(rcsfgenerate::Rcsfgenerate)
        configurations = DestructConfigurations(rcsfgenerate)
        getproperty(configurations, "Configs")
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


    function WriteRcsfgenerateInput(calc_dir::String,rcsfgenerate::Rcsfgenerate)
        input_dir = joinpath(calc_dir,"input")
        input_dir = Basics.InitDirectory(input_dir);
        Base.cd(input_dir);
        filepath= joinpath(input_dir,"rcsfgenerate.inp")
        # Base.mkpath(filepath) # create
        io = open(filepath,"w")
        core = GetCore(rcsfgenerate);
        configs = GetConfigurations(rcsfgenerate);
        Jl= GetJl(rcsfgenerate);
        Jh= GetJh(rcsfgenerate);
        noex= Getnoex(rcsfgenerate);
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
        calc_dir = Basics.InitDirectory(getproperty(rcsfgenerate,"calc_dir"));
        isempty(calc_dir) && error("Invalid path");
        filepath=WriteRcsfgenerateInput(calc_dir, rcsfgenerate)
        !Base.isfile(joinpath(calc_dir,"isodata")) && error("No isodata file exists, you should run Rnucleus command first")
        Base.cd(calc_dir);
        noex= Getnoex(rcsfgenerate);
        out_dir = joinpath(calc_dir,"output")
        out_dir= Basics.InitDirectory(out_dir);
        out_file = joinpath(out_dir,"rcsfgenerate.out")

        run(pipeline(filepath,`rcsfgenerate`, out_file))

        CreateBlocksFile(calc_dir, out_file)
        GetNoCSF( calc_dir, out_file)
        Base.cp("rcsf.out", "rcsf.inp",force=true)
        (noex == 0) && Base.cp("rcsf.out", "rcsfmr.inp",force=true)

        println("================================= Rcsfgenerate Calc Finished======================================")
    
    end
    function GetNoCSF( calc_dir::String, outfilepath::String)
        lines= Basics.ReadFileLines(outfilepath)
        name= "configuration states in the final list"
        # reg_ex = Regex(r"^(?<n>\d+)\s\\Q$name\\E\.")
        CSFfilepath = joinpath(calc_dir, "CSF.txt")
        io = open(CSFfilepath,"w")
        regex_name =r"^\s(?<n>\d+)\s\bconfiguration states in the final lis.\b"
        csf=0
        for line in lines
            m = match(regex_name, line)
           if m !== nothing 
            csf=  m.captures[1];
           end
        end
        write(io,csf*"\n");
        close(io)
    end
    function CreateBlocksFile( calc_dir::String, outfilepath::String)
        lines= Basics.ReadFileLines(outfilepath)
        sStart="       block  J/P            NCSF"
        i=Basics.FindStringIndexInVector(sStart, lines)
        blocks= lines[i+1:end]
        blockfilepath = joinpath(calc_dir, "blocks.txt")
        io = open(blockfilepath,"w")
        for line in blocks
            cols = Base.split(Base.strip(line)," ")
            write(io,"1,"*cols[end]*"\n");
        end
        close(io)
        
    end
end