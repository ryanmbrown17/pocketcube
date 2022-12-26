#########################
# Adding Packages #
#########################
import Pkg
#Pkg.add("Combinatorics")
#Pkg.add("BenchmarkTools")
#Pkg.add("LoopVectorization")
#Pkg.add("LinearAlgebra")
#Pkg,add("JLD2")
#########################
# Includes #
#########################
using FileIO 
using JLD2
using Combinatorics
using BenchmarkTools
using LinearAlgebra
using SparseArrays 
using Base.Threads: @threads, @sync, @spawn
using GraphRecipes, Plots
using Graphs
using GraphPlot
#########################
# Guido Dipietro - 2020 #
#########################
cp = (1,2,3,4,5,6,7,8) # like,speffz 
co = (0,0,0,0,0,0,0,0) # 1 = clockwise
initial = (cp, co) 
# Atoms 
const Rp((a,b,c,d,e,f,g,h)) = (a,c,f,d,e,g,b,h)
const Ro(a) = @. (a + (0,1,2,0,0,1,2,0)) % 3
const Up((a,b,c,d,e,f,g,h)) = (d,a,b,c,e,f,g,h) 
const xp((a,b,c,d,e,f,g,h)) = (d,c,f,e,h,g,b,a)
const xo(a) = @. (a + (2,1,2,1,2,1,2,1)) % 3
# Movedefs
const R((p,o)) = Rp(p), (Ro∘Rp)(o)
const U((p,o)) = Up(p), Up(o)
const x((p,o)) = xp(p), (xo∘xp)(o)
const D = x ∘ x ∘ U ∘ x ∘ x 
const y = U ∘ D ∘ D ∘ D   ## Test if composition is saved, or matrix algebra done
const F = x ∘ x ∘ x ∘ U ∘ x
const B = y ∘ y ∘ F ∘ y ∘ y
const z = F ∘ B ∘ B ∘ B
const L = y ∘ y ∘ R ∘ y ∘ y
#########################
# Ryan Brown- 2022 #
#########################
mutable struct DIRECTED_GRAPH
    from::Int
    to::Vector{Int}
    times::Vector{Int8}
end


mutable struct CUBE
    c1::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}
    c2::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}
    c3::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}
    c4::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}
    c5::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}
    c6::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}
    c7::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}
    c8::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}
    c9::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}
    c10::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}
    c11::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}
    c12::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}
    c13::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}
    c14::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}
    c15::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}
    c16::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}
    c17::Tuple{NTuple{8, Int64}, NTuple{8, Int64}} 
    c18::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}
    c19::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}
    c20::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}
    c21::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}
    c22::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}
    c23::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}
    c24::Tuple{NTuple{8, Int64}, NTuple{8, Int64}}  
end

function INIT_CUBE()
    return CUBE(initial,(transforms[1],(0,0,0,0,0,0,0,0)),(transforms[2],(0,0,0,0,0,0,0,0)),(transforms[3],(0,0,0,0,0,0,0,0)),(transforms[4],(2,1,2,1,2,1,2,1)),(transforms[5],(2,1,2,1,2,1,2,1)),(transforms[6],(2,1,2,1,2,1,2,1)),(transforms[7],(2,1,2,1,2,1,2,1)),(transforms[8],(1,2,1,2,1,2,1,2)) , (transforms[9],(1,2,1,2,1,2,1,2)) , (transforms[10],(1,2,1,2,1,2,1,2)), (transforms[11],(1,2,1,2,1,2,1,2)) , (transforms[12],(2,1,2,1,2,1,2,1)), (transforms[13],(2,1,2,1,2,1,2,1)), (transforms[14],(2,1,2,1,2,1,2,1)), (transforms[15],(2,1,2,1,2,1,2,1)), (transforms[16],(1,2,1,2,1,2,1,2)), (transforms[17],(1,2,1,2,1,2,1,2)), (transforms[18],(1,2,1,2,1,2,1,2)), (transforms[19],(1,2,1,2,1,2,1,2)), (transforms[20],(0,0,0,0,0,0,0,0)), (transforms[21],(0,0,0,0,0,0,0,0)), (transforms[22],(0,0,0,0,0,0,0,0)), (transforms[23],(0,0,0,0,0,0,0,0)))
end

function turns(before::CUBE,move)
    after = INIT_CUBE()
    after.c1 = (move)(before.c1)
    after.c2 = (move)(before.c2)
    after.c3 = (move)(before.c3)
    after.c4 = (move)(before.c4)
    after.c5 = (move)(before.c5)
    after.c6 = (move)(before.c6)
    after.c7 = (move)(before.c7)
    after.c8 = (move)(before.c8)
    after.c9 = (move)(before.c9)
    after.c10 = (move)(before.c10)
    after.c11 = (move)(before.c11)
    after.c12 = (move)(before.c12)
    after.c13 = (move)(before.c13)
    after.c14 = (move)(before.c14)
    after.c15 = (move)(before.c15)
    after.c16 = (move)(before.c16)
    after.c17 = (move)(before.c17)
    after.c18 = (move)(before.c18)
    after.c19 = (move)(before.c19)
    after.c20 = (move)(before.c20)
    after.c21 = (move)(before.c21)
    after.c22 = (move)(before.c22)
    after.c23 = (move)(before.c23)
    after.c24 = (move)(before.c24)
    return after
end

function orientate_CUBE(cube::CUBE)
    c = INIT_CUBE()
    c.c1 = orientate_cube(cube.c1)
    c.c2 = orientate_cube(cube.c2)
    c.c3 = orientate_cube(cube.c3)
    c.c4 = orientate_cube(cube.c4)
    c.c5 = orientate_cube(cube.c5)
    c.c6 = orientate_cube(cube.c6)
    c.c7 = orientate_cube(cube.c7)
    c.c8 = orientate_cube(cube.c8)
    c.c9 = orientate_cube(cube.c9)
    c.c10 = orientate_cube(cube.c10)
    c.c11 = orientate_cube(cube.c11)
    c.c12 = orientate_cube(cube.c12)
    c.c13 = orientate_cube(cube.c13)
    c.c14 = orientate_cube(cube.c14)
    c.c15 = orientate_cube(cube.c15)
    c.c16 = orientate_cube(cube.c16)
    c.c17 = orientate_cube(cube.c17)
    c.c18 = orientate_cube(cube.c18)
    c.c19 = orientate_cube(cube.c19)
    c.c20 = orientate_cube(cube.c20)
    c.c21 = orientate_cube(cube.c21)
    c.c22 = orientate_cube(cube.c22)
    c.c23 = orientate_cube(cube.c23)
    c.c24 = orientate_cube(cube.c24)
    return c
end

#Constants
color_table = [['y','g','o'],['y','r','g'],['y','b','r'],['y','o','b'],['w','b','o'],['w','r','b'],['w','g','r'],['w','o','g']]
const transforms = [ 
    ##Not Shown Y->Y, B->B
    (4,1,2,3,6,7,8,5), ##Y->Y B->O
    (3,4,1,2,7,8,5,6), ## B->G
    (2,3,4,1,8,5,6,7), ## B->R
    (6,5,4,3,2,1,8,7), ## Y->B, B->Y
    (5,8,1,4,3,2,7,6), ##B->O
    (8,7,2,1,4,3,6,5), ##B->W
    (7,6,3,2,1,4,5,8), ## B->R
    (1,8,7,2,3,6,5,4), ## Y->O, B->B
    (2,7,6,3,4,5,8,1), ## B->Y
    (3,6,5,4,1,8,7,2), ## B->G
    (4,5,8,1,2,7,6,3), ## B->W
    (2,1,8,7,6,5,4,3), ## Y->G, B->W
    (3,2,7,6,5,8,1,4), ##B->O
    (4,3,6,5,8,7,2,1), ## B->Y
    (1,4,5,8,7,6,3,2), ## B-> R
    (8,1,4,5,6,3,2,7), ## Y->R,B->B
    (7,2,1,8,5,4,3,6), ## B -> Y
    (5,4,3,6,7,2,1,8), ## B -> G
    (6,3,2,7,8,1,4,5),  ## B -> W
    (7,8,5,6,3,4,1,2), ## Y->w, B->B
    (6,7,8,5,4,1,2,3), ## B->O
    (5,6,7,8,1,2,3,4), ## B ->g
    (8,5,6,7,2,3,4,1)] ## B ->r
const arr_moves = [R,R∘R∘R,D,D∘D∘D,B,B∘B∘B]
const Arr1 = collect(permutations((1,2,3,4,5,6,7,8)));

##Position is:
#0-Top/Bottom
#1-Right of Top
#2-Left of Top
function color(position, cubie,orientation)
   return color_table[cubie][1+mod(orientation+position,3)]
end

function print_cube(cube)
    print_cube(cube[1],cube[2])
end

function print_cube(cp,co)
    print("   \\  ",color(0,cp[1],co[1]),' ',color(0,cp[2],co[2]))
    print("  /","",'\n',"    \\ ",color(0,cp[4],co[4]),' ',color(0,cp[3],co[3])," / ",'\n')
    print(color(2,cp[1],co[1])," ",color(1,cp[4],co[4])," | ",color(2,cp[4],co[4])," ",color(1,cp[3],co[3])," | ",color(2,cp[3],co[3])," ",color(1,cp[2],co[2]),'\n')
    print(color(1,cp[8],co[8])," ",color(2,cp[5],co[5])," | ",color(1,cp[5],co[5])," ",color(2,cp[6],co[6])," | ",color(1,cp[6],co[6])," ",color(2,cp[7],co[7]),'\n')
    print("    / ",color(0,cp[5],co[5])," ",color(0,cp[6],co[6])," \\",'\n')
    print("   /  ",color(0,cp[8],co[8])," ",color(0,cp[7],co[7]),"  \\ ",'\n','\n')
    print("      ",color(1,cp[1],co[1])," ",color(2,cp[2],co[2]),'\n')
    print("      ",color(2,cp[8],co[8])," ",color(1,cp[7],co[7]))
end

# Orientate cube by cubie 4 in position 4, yellow ontop
function orientate_cube(cu)
    if(cu[1][4]==4)
    elseif(cu[1][3] == 4 || cu[1][6]==4 || cu[1][5]==4)
        while(cu[1][4]!=4)
            cu = z(cu)
        end
    elseif(cu[1][1]==4 || cu[1][8]==4)
        while(cu[1][4]!=4)
           cu = x(cu)
        end
    else
        cu = y(cu)
        return orientate_cube(cu)
    end
    if(cu[2][4] == 0) 
        return cu
    elseif(cu[2][4]==1)
        cu = (y∘y∘y∘x)(cu) #y inverse
    else
        cu = (x∘x∘x∘y)(cu) #x inverse 
    end    
    return cu
end


##CANONICAL REPRESENTATIVES

function canonical_representative(cube::CUBE)
    cube_n = orientate_CUBE(cube)
    class = Vector(undef,24)
    class[1] = cube_to_pos(cube_n.c1)+1
    class[2] = cube_to_pos(cube_n.c2)+1
    class[3] = cube_to_pos(cube_n.c3)+1
    class[4] = cube_to_pos(cube_n.c4)+1
    class[5] = cube_to_pos(cube_n.c5)+1
    class[6] = cube_to_pos(cube_n.c6)+1
    class[7] = cube_to_pos(cube_n.c7)+1
    class[8] = cube_to_pos(cube_n.c8)+1
    class[9] = cube_to_pos(cube_n.c9)+1
    class[10] = cube_to_pos(cube_n.c10)+1
    class[11] = cube_to_pos(cube_n.c11)+1
    class[12] = cube_to_pos(cube_n.c12)+1
    class[13] = cube_to_pos(cube_n.c13)+1
    class[14] = cube_to_pos(cube_n.c14)+1
    class[15] = cube_to_pos(cube_n.c15)+1
    class[16] = cube_to_pos(cube_n.c16)+1
    class[17] = cube_to_pos(cube_n.c17)+1
    class[18] = cube_to_pos(cube_n.c18)+1
    class[19] = cube_to_pos(cube_n.c19)+1
    class[20] = cube_to_pos(cube_n.c20)+1
    class[21] = cube_to_pos(cube_n.c21)+1
    class[22] = cube_to_pos(cube_n.c22)+1
    class[23] = cube_to_pos(cube_n.c23)+1
    class[24] = cube_to_pos(cube_n.c24)+1
    return minimum(class)
end

function number_to_trinary_array(num)
    array = [0,0,0,0,0,0,0,0]
    for i in 1:8
        array[i]=num%3
        num = floor(num/3)
    end
    return Tuple(array)
end

function trinary_array_to_number(array)
    num =0;
    for i in 1:8
        num += array[i]*3^(i-1)
    end
    return num
end

function pos_to_cube(pos)
   or_arr = number_to_trinary_array(pos%(3^8))
   pos_arr = Tuple(Arr1[convert(Int,floor(pos/(3^8))+1)])
   return (pos_arr,or_arr)
end

function decrement_array(array,num)
    array=collect(array)
    for i in 1:(size(array)[1])
        if(array[i]>num) 
            array[i] = array[i]-1 
        end
    end
    return Tuple(array)
end

function array_to_num(array)
    pos= (array[1]-findmin(array)[1])*factorial(7)
    for i in 1:6
        array = decrement_array(array[2:(9-i)],array[1])
        pos += (array[1]-findmin(array)[1])*factorial(7-i)
    end
    return pos
end

function cube_to_pos(cube) 
   return array_to_num(cube[1])*3^8+trinary_array_to_number(cube[2])
end

function moves(cube)
    array_pos = Vector{Int}(undef, 12) 
    @threads for i in 1:12
        array_pos[i] = cube_to_pos((arr_moves[i])(cube))+1
    end
    return array_pos
end

function add_moves(v)
    new_v = Vector(undef,12)
    @threads for i in 1:12
        new_v[i] = v∘arr_moves[i]
    end
    return new_v
end


function add_to_directed_graph(cube_pos, array_pos, dir)
    d_n = DIRECTED_GRAPH(cube_pos,unique(array_pos),[count(==(element),array_pos) for element in unique(array_pos) ])
    push!(dir,d_n)
    return dir
end



## Recursively Adds, Took too much time, uses a lot of memory
#function recursive_add(cube,directed_graph,depth,deep)
#    cube_pos = cube_to_pos(cube);
#    if(!isempty(nonzeros(directed_graph[cube_pos+1,:])))  
#        return 
#    end
#    if(depth >= deep) return end
#   for i in 1:12
#        new_cube = arr_moves[i](cube)
#        directed_graph[cube_pos+1,cube_to_pos(new_cube)+1]=1
#        recursive_add(new_cube,directed_graph,depth+1,deep)
#    end
#end
#
#function generate_recursive(deep)
#    directed_graph = spzeros(264539520,264539520)
#    recursive_add(pos_to_cube(0),directed_graph,0,deep)
#    return directed_graph
#end

function generate_itterative(depth)
    been_to = BitVector(undef,264539520)
    cube = INIT_CUBE()
    been_to[1] = 1
    output = arr_moves
    output_cubes = Vector{Int}(undef,0)
    oc_multiples = Vector{Int}(undef,0)
    output_new = Vector{Any}(undef,0)
    for i in 1:6
        new = canonical_representative(turns(cube,output[i]))
        if (been_to[new] == 0) 
            push!(output_cubes,new)
            push!(output_new,output[i])
            push!(oc_multiples,1)
            been_to[new] = 1
        else
            oc_multiples[findall(x->x==new,output_cubes)[1]]+=1
        end
    end
        @info "Completed 1"
         save("1.jld2"; output_cubes = output_cubes, oc_multiples= oc_multiples, d=0)
         save("resume.jld2";been_to=been_to,output=output)  
    for  i in  1:depth
        if(!isempty(output_new))   
            output = output_new
            output_new = Vector{Any}(undef,0)
            for j in 1:length(output)
                oc_multiples = Vector{Int}(undef,0)
               output_cubes =  Vector{Int}(undef,0)
                for k in 1:6
                    new = canonical_representative(turns(cube,output[j]∘arr_moves[k]))
                    if(been_to[new]==0)
                       push!(output_cubes,new)
                       push!(output_new,output[j]∘arr_moves[k])
                        push!(oc_multiples,1)
                        been_to[new] = 1
                    elseif (new in output_cubes)
                      oc_multiples[findall(x->x==new,output_cubes)[1]]+=1
                    else 
                        push!(output_cubes,new)
                        push!(oc_multiples,1)
                    end
                end
                @info string("Completed ",canonical_representative(turns(cube,output[j])))
                save(string(canonical_representative(turns(cube,output[j])),".jld2"); output_cubes= output_cubes, oc_multiples=oc_multiples, d=i)
                ouput_current = output[j:length(output)]
                save("resume.jld2";been_to=been_to, ouput_current=ouput_current,output_new= output_new,depth=depth) 
            end 
        end
    end
end
function resume()
    cube = INIT_CUBE()
    been_to = load("resume.jld2","been_to")
    ouput_current = load("resume.jld2","ouput_current")
    output_new  = load("resume.jld2","output_new")
    depth = load("resume.jld2","depth") 
    if(!isempty(ouput_current))
        output = ouput_current
         for j in 1:length(output)
                oc_multiples = Vector{Int}(undef,0)
                output_cubes =  Vector{Int}(undef,0)
                for k in 1:6
                    new = canonical_representative(turns(cube,output[j]∘arr_moves[k]))
                    if(been_to[new]==0)
                        push!(output_cubes,new)
                        push!(output_new,output[j]∘arr_moves[k])
                        push!(oc_multiples,1)
                        been_to[new] = 1
                    elseif (new in output_cubes)
                        oc_multiples[findall(x->x==new,output_cubes)[1]]+=1
                    else 
                        push!(output_cubes,new)
                        push!(oc_multiples,1)
                    end
                end
                @info string("Completed ",canonical_representative(turns(cube,output[j])))
                save(string(canonical_representative(turns(cube,output[j])),".jld2"); output_cubes=output_cubes, oc_multiples=oc_multiples, d=i)
                ouput_current = output[j:length(output)]
                save("resume.jld2";been_to=been_to, ouput_current=ouput_current, output_new=output_new,depth=depth,output=output,j=j) 
            end
    end
     for  i in  (depth+1):20
        if(!isempty(output_new))   
            output = output_new
            output_new = Vector{Any}(undef,0)
            for j in 1:length(output)
                oc_multiples = Vector{Int}(undef,0)
                output_cubes =  Vector{Int}(undef,0)
                for k in 1:6
                    new = canonical_representative(turns(cube,output[j]∘arr_moves[k]))
                    if(been_to[new]==0)
                        push!(output_cubes,new)
                        push!(output_new,output[j]∘arr_moves[k])
                        push!(oc_multiples,1)
                        been_to[new] = 1
                    elseif (new in output_cubes)
                        oc_multiples[findall(x->x==new,output_cubes)[1]]+=1
                    else 
                        push!(output_cubes,new)
                        push!(oc_multiples,1)
                    end
                end
                @info string("Completed ",canonical_representative(turns(cube,output[j])))
                save(string(canonical_representative(turns(cube,output[j])),".jld2"); output_cubes=output_cubes, oc_multiples=oc_multiples, d=i)
                ouput_current = output[j:length(output)]
                save("resume.jld2";been_to=been_to, ouput_current=ouput_current, output_new=output_new,depth=depth,output=output,j=j) 
            end
        end
    end

end

#function next_level()
#    cube = INIT_CUBE()
#    been_to = load("resume.jld2","been_to")
#    output_new  = load("resume.jld2","output_new")
#    depth = load("resume.jld2","depth")
#    for  i in  depth:(depth+1)
#        if(!isempty(output_new))   
#            output = output_new
#            output_new = Vector{Any}(undef,0)
#            for j in 1:length(output)
#                oc_multiples = Vector{Int}(undef,0)
#                output_cubes =  Vector{Int}(undef,0)
#                for k in 1:6
#                    new = canonical_representative(turns(cube,output[j]∘arr_moves[k]))
#                    if(been_to[new]==0)
#                        push!(output_cubes,new)
#                        push!(output_new,output[j]∘arr_moves[k])
#                        push!(oc_multiples,1)
#                        been_to[new] = 1
#                    elseif (new in output_cubes)
#                        oc_multiples[findall(x->x==new,output_cubes)[1]]+=1
#                    else 
#                        push!(output_cubes,new)
#                        push!(oc_multiples,1)
#                    end
#                end
#                @info string("Completed ",canonical_representative(turns(cube,output[j])))
#                save(string(canonical_representative(turns(cube,output[j])),".jld2"); output_cubes, oc_multiples, d=i)
#                ouput_current = output[j:length(output)]
#                save("resume.jld2";been_to, ouput_current, output_new,depth,output,j) 
#            end
#        end
#    end
#end

function graph(depth)
    ##Directed Graph Setup
    directed_graph = spzeros(264539520,264539520)
    counter = 1
    nodes = [1]
    new_nodes = Vector{Int}(undef,0)
    new_weights = Vector{Int}(undef,0)
    for d in 0:depth
        for counter in counter:length(nodes)
            empty!(new_nodes)
            empty!(new_weights)
            name = string(nodes[counter],".jld2")
            new_nodes = load(name,"output_cubes")
            new_weights = load(name,"oc_multiples")
            for i in 1:length(new_nodes)
                if (!(new_nodes[i] in nodes)) 
                    push!(nodes,new_nodes[i])
                end
                directed_graph[nodes[counter],new_nodes[i]] = new_weights[i]
            end
        end
        counter +=1
    end
        ##Reduction of directed graph
    name_vec = unique(Vcat(findnz(directed_graph)[1],findnz(directed_graph)[2]))
    count = length(name_vec)
    name_dic = Dict()
    for i in 1:count
        name_dic[name_vec[i]]=i 
    end
    reduced_graph = spzeros(count,count)
    entry_count = length(findnz(directed_graph)[1])
    for i in 1:entry_count
        reduced_graph[name_dic[findnz(directed_graph)[1][i]],name_dic[findnz(directed_graph)[2][i]]]=findnz(directed_graph)[3][i]
    end

    #edgelabel_dict = Dict()
    #for i in 1:count
    #    for j in 1:count
    #        edgelabel_dict[(i, j)]= string(reduced_graph[i,j])
    #    end 
    #end
    graphplot(reduced_graph,names=name_vec, shorten=0.01) #edgelabel=edgelabel_dict)
end