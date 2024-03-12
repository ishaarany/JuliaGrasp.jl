"""
`module  JuliaGrasp.Basics`  
    ... a submodel of JuliaGRASP that contains many basic types/struct that are specific to the JAC module; this module also defines
        a number of basic functions/methods that are later extended. We here provide proper docstrings for all abstract and
        concrete types (struct).
"""
module Basics

    using Printf, QuadGK

    export FindStringIndexInVector, FindStringsIndeciesInVector, ReadFileLines, InitDirectory


    """
    `Basics.FindStringInVector(s::String, v::Vector)`  ... Find indecies for a given Strings in Vector(Stings) ... .
    """
    function FindStringIndexInVector(s::String, v::Vector{String})
        index = findall(in([s]), v)
        !(length(index)==1)      &&   error("Unrecognized string = $s")
        return(index[1])   
    end



    """
    `Basics.GetBlocks()`  ... Read Blocks from mr folder ...
    """
    function GetBlocks(principle_orbital::Int64, state_folder::String)
        for n in range(start=principle_orbital, step=1, stop=1)
            blockfolderpath = joinpath(state_folder, "n"*string(n), "mr" ,"output")
            blockfilepath = joinpath(blockfolderpath, "blocks.txt")
            println("\n\n"*blockfilepath*"\n\n")
            if(isfile(blockfilepath))
                return ReadFileLines(blockfilepath)
            end        
        end
        error("Blocks file does not exist")
    end



    """
    `Basics.FindStringsIndeciesInVector(sStart::String, sEnd::String, v::Vector)`  ... Find an index of a given String in Vector(Stings) ... .
    """
    function FindStringsIndeciesInVector(sStart::String, sEnd::String, v::Vector{String})

        startIndex = FindStringIndexInVector(sStart, v)
        !(length(startIndex)==1)      &&   error("Unrecognized string = $sStart")


        endIndex = FindStringIndexInVector(sEnd, v)
        !(length(endIndex)==1)      &&   error("Unrecognized string = $sEnd")

        ( startIndex > endIndex)      &&   error("Start string= $sStart should comes before end String= $sEnd ")

        return(startIndex, endIndex)
    end


    """
    `Basics.ReadFileLines(filepath::String)`  ... return file lines as Vector{String} ... .
    """
    function ReadFileLines(filepath::String)

        try
            f= open(filepath,"r"); 
            return file_lines = readlines(f);
        catch
            # either warn or print that the file doesn't exist
            error("file doesn't exist")
        end

    end

    function InitDirectory(calc_path::String)
        Base.mkpath(calc_path)
    end


    #  function will be define letters
    function Execute() end
    function PerformCalc() end
    # filepath = "/home/ibs/GRASP2018/work/W/W+68/C-like/even/out/mr-even--rlevels1"

    # f= ReadFileLines(filepath)
    # @show f

    # f = [ "s", "p", "d", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "q", "r", "t", "u", "v", "w", "x", "y", "z"]
    # s= "f"
    # e="m"
    # indecies = FindStringsIndeciesInVector(e, s, f)
#    @show indecies[2]
end