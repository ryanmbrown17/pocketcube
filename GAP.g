R:= (13,14,16,15)(10,2,19,22)(12,4,17,24);
D:= (21,22,24,23)(11,15,19,7)(12,16,20,8);
B:= (17,18,20,19)(2,5,23,16)(1,7,24,14);
G := Group(R,B,D);

GrowthFunctionOfGroup(G,1);

F := FreeGroup("R","B","D");
hom := GroupHomomorphismByImages(F,G,GeneratorsOfGroup(F),GeneratorsOfGroup(G));

LoadPackage("Grape");
CayleyGraph(G,GeneratorsOfGroup(F));


PrintTo("Filename",code);



G_E := Elements(G);;
PreImagesRepresentative( hom, G_E[i]);


PrintTo("Test.txt","test")


R:= (13,14,16,15)(10,2,19,22)(12,4,17,24);
D:= (21,22,24,23)(11,15,19,7)(12,16,20,8);
B:= (17,18,20,19)(2,5,23,16)(1,7,24,14);
G := Group(R,B,D);
GrowthFunctionOfGroup(G,14);
F := FreeGroup("R","B","D");
hom := GroupHomomorphismByImages(F,G,GeneratorsOfGroup(F),GeneratorsOfGroup(G));
G_E := Elements(G);;
for i in [1..Length(G_E)] do
	AppendTo("Elements.txt",i,":",PreImagesRepresentative( hom, G_E[i]),"\n")	;
od;
for i in [1..Length(G_E)] do
	AppendTo("Graph.txt",i,":",Position(G_E,R*G_E[i]),",",Position(G_E,B*G_E[i]),",",Position(G_E,D*G_E[i]),"\n");
od;

for i in [1..50] do

AppendTo("Graph.txt",i,":",Position(G_E,R*G_E[i]),",",Position(G_E,B*G_E[i]),",",Position(G_E,D*G_E[i]),",",Position(G_E,R^(-1)*G_E[i]),",",Position(G_E,B^(-1)*G_E[i]),",",Position(G_E,D^(-1)*G_E[i]),"\n");

od;