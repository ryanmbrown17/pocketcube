using Combinatorics
using SparseArrays
using SuiteSparse
using DataStructures
using Benchmarks
#########################
# Guido Dipietro - 2020 #
#########################
cp = (1,2,3,4,5,6,7,8) # like,speffz
co = (0,0,0,0,0,0,0,0) # 1 = clockwise
cube = (cp, co)

# Atoms
Rp((a,b,c,d,e,f,g,h)) = (a,c,f,d,e,g,b,h)
Ro(a) = @. (a + (0,1,2,0,0,1,2,0)) % 3
Up((a,b,c,d,e,f,g,h)) = (d,a,b,c,e,f,g,h)
xp((a,b,c,d,e,f,g,h)) = (d,c,f,e,h,g,b,a)
xo(a) = @. (a + (2,1,2,1,2,1,2,1)) % 3

# Movedefs
R((p,o)) = Rp(p), (Ro∘Rp)(o)
U((p,o)) = Up(p), Up(o)
x((p,o)) = xp(p), (xo∘xp)(o)
D = x ∘ x ∘ U ∘ x ∘ x
y = U ∘ D ∘ D ∘ D   ## Test if composition is saved, or matrix algebra done
F = x ∘ x ∘ x ∘ U ∘ x
B = y ∘ y ∘ F ∘ y ∘ y
z = F ∘ B ∘ B ∘ B
L = y ∘ y ∘ R ∘ y ∘ y

#########################
# Ryan Brown- 2022 #
#########################
color_table = [['y','g','o'],['y','r','g'],['y','b','r'],['y','o','b'],['w','b','o'],['w','r','b'],['w','g','r'],['w','o','g']]

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
function orientate_cube(cube)
    if(cube[1][4]==4)
    elseif(cube[1][3] == 4 || cube[1][6]==4 || cube[1][5]==4)
        while(cube[1][4]!=4)
            cube = z(cube)
        end
    elseif(cube[1][1]==4 || cube[1][8]==4)
        while(cube[1][4]!=4)
           cube = x(cube)
        end
    else
        cube = y(cube)
        return orientate_cube(cube)
    end
    if(cube[2][4] == 0) 
        return cube
    elseif(cube[2][4]==1)
        cube = y(y(y(cube))) #y inverse
        cube = z(z(z(cube))) #z inverse 
    else
        cube = y(cube)
        cube = x(x(x(cube))) #x inverse
    end    
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

Arr1 = collect(permutations((1,2,3,4,5,6,7,8)));

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
   num = 0;
   num += array_to_num(cube[1])*3^8
   num += trinary_array_to_number(cube[2])
end

function add_to_directed_graph(cube, directed_graph)
    cube_pos = cube_to_pos(cube)
    output_array=[R(cube),(R∘R∘R)(cube),L(cube),(L∘L∘L)(cube),U(cube),(U∘U∘U)(cube),D(cube),(D∘D∘D)(cube),F(cube),(F∘F∘F)(cube),B(cube),(B∘B∘B)(cube)]
    array_pos = [0,0,0,0,0,0,0,0,0,0,0,0]
    array_pos[1]=cube_to_pos((output_array[1][1],output_array[1][2]))
    array_pos[2]=cube_to_pos((output_array[2][1],output_array[2][2]))
    array_pos[3]=cube_to_pos((output_array[3][1],output_array[3][2]))
    array_pos[4]=cube_to_pos((output_array[4][1],output_array[4][2]))
    array_pos[5]=cube_to_pos((output_array[5][1],output_array[5][2]))
    array_pos[6]=cube_to_pos((output_array[6][1],output_array[6][2]))
    array_pos[7]=cube_to_pos((output_array[7][1],output_array[7][2]))
    array_pos[8]=cube_to_pos((output_array[8][1],output_array[8][2]))
    array_pos[9]=cube_to_pos((output_array[9][1],output_array[9][2]))
    array_pos[10]=cube_to_pos((output_array[10][1],output_array[10][2]))
    array_pos[11]=cube_to_pos((output_array[11][1],output_array[11][2]))
    array_pos[12]=cube_to_pos((output_array[12][1],output_array[12][2]))
    
    directed_graph[cube_pos+1,array_pos[1]+1]+=1
    directed_graph[cube_pos+1,array_pos[2]+1]+=1
    directed_graph[cube_pos+1,array_pos[3]+1]+=1
    directed_graph[cube_pos+1,array_pos[4]+1]+=1
    directed_graph[cube_pos+1,array_pos[5]+1]+=1
    directed_graph[cube_pos+1,array_pos[6]+1]+=1
    directed_graph[cube_pos+1,array_pos[7]+1]+=1
    directed_graph[cube_pos+1,array_pos[8]+1]+=1
    directed_graph[cube_pos+1,array_pos[9]+1]+=1
    directed_graph[cube_pos+1,array_pos[10]+1]+=1
    directed_graph[cube_pos+1,array_pos[11]+1]+=1
    directed_graph[cube_pos+1,array_pos[12]+1]+=1
    
    return array_pos .+ 1
end

arr_moves = (R,R∘R∘R,L,L∘L∘L,U,U∘U∘U,D,D∘D∘D,F,F∘F∘F,B,B∘B∘B)

function recursive_add(cube,directed_graph,depth,deep)
    cube_pos = cube_to_pos(cube);
    if(!isempty(nonzeros(directed_graph[cube_pos+1,:])))  
        return 
    end
    if(depth >= deep) return end
    for i in 1:12
        new_cube = arr_moves[i](cube)
        directed_graph[cube_pos+1,cube_to_pos(new_cube)+1]=1
        recursive_add(new_cube,directed_graph,depth+1,deep)
    end
end

function generate_recursive(deep)
    directed_graph = spzeros(264539520,264539520)
    recursive_add(pos_to_cube(0),directed_graph,0,deep)
    return directed_graph
end

function generate_itterative(itt)
    q = Queue{Int}()
    directed_graph = spzeros(264539520,264539520)
    been_to = zeros(264539520)
    output = add_to_directed_graph(pos_to_cube(0),directed_graph)
    enqueue!(q,output[1])
    enqueue!(q,output[2])
    enqueue!(q,output[3])
    enqueue!(q,output[4])
    enqueue!(q,output[5])
    enqueue!(q,output[6])
    enqueue!(q,output[7])
    enqueue!(q,output[8])
    enqueue!(q,output[9])
    enqueue!(q,output[10])
    enqueue!(q,output[11])
    enqueue!(q,output[12])
    i = 0;
    while (!(isempty(q)) && i<=itt)      
         if(been_to[first(q)] == 0) 
            output = add_to_directed_graph(pos_to_cube(first(q)),directed_graph)
            been_to[first(q)] = 1
            enqueue!(q,output[1])
            enqueue!(q,output[2])
            enqueue!(q,output[3])
            enqueue!(q,output[4])
            enqueue!(q,output[5])
            enqueue!(q,output[6])
            enqueue!(q,output[7])
            enqueue!(q,output[8])
            enqueue!(q,output[9])
            enqueue!(q,output[10])
            enqueue!(q,output[11])
            enqueue!(q,output[12])
            dequeue!(q)
        end  
        i+=1;
    end
    return directed_graph
end
