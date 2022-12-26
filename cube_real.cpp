#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <cstdio>
#include <queue>
#include <map>

using namespace std;

class state
{
public:
	state();
	state(int id_n);
	~state();

	int get_id(){return id;};
	int* get_to(){return to;};
	int get_to(int i){return to[i];};
	string get_name(){return name;};
	int get_depth(){return depth;};

	void set_id(int id_n){id = id_n;};
	void set_to(int to_n, int i){to[i]=to_n;};
	void set_name(string str){name = str;};
	void set_depth(int depth_n){depth=depth_n;};
	void append_name(string str){name += str;};

private:
	int id;
	int depth;
	int* to;
	string name;
};

int get_num(string& str, int& i);
void name_cubes(vector<state>& v);
void name_state(state& s1, state& s2, string str);

int main(int argc, char const *argv[])
{
	/*
	ifstream fp;fp.open("order.csv");
	map<int,int> dict;
	string name;
	int n;
	int j;
	for(int i=0;i<3674160;i++)
	{
		j=0;
		fp >> name;
		n = get_num(name,j);
		dict.insert({n,i+1});
	}
	fp.close();

	fp.open("Graph.csv");
	ofstream f; f.open("graph_rename.csv");

	string graph;
	fp >> graph;
	for(int k=0;k<3674160;k++) //3674160
	{
		fp >> graph;
		int i=0;
		f << dict[get_num(graph,i)];
		for(int j=0;j<6;j++)
		{
			f << ',' << dict[get_num(graph,i)];
		}
		f << endl;
	}

	fp.close();f.close(); */
	
	/*ifstream fp; fp.open("Graph.csv");
	string graph;
	vector<state> v;
	fp >> graph;
	for(int k=0;k<3674160;k++) //3674160
	{
		fp >> graph;
		int i=0;
		state s = state(get_num(graph,i));
		v.push_back(s);
		for(int j=0;j<6;j++)
		{
			v[k].set_to(get_num(graph,i), j);
		}
	}
	fp.close();
	name_cubes(v);*/
	return 0;
}


int get_num(string& str, int& i)
{
	int start = i;
	for(;i<str.size() && str[i]!=',';i++);
	int ret = stoi(str.substr(start,i));
	i+=1;
	return ret;
}
void name_cubes(vector<state>& v)
{
	state current = v[0];
	current.set_name("");
	current.set_depth(0);
	vector<int> id_vec;
	queue<int> current_list;
	bool been_to[3674160];
	for(int i =0; i< 3674160;i++)
	{
		been_to[i]=false;
	}
	int* to_name = v[0].get_to();
	ofstream f; f.open("order.csv");
	for(int i=0;i<6;i++) 
	{
		id_vec.push_back(to_name[i]);
	}
	for(int i=0;i<id_vec.size();i++)
	{
		name_state(current,v[id_vec[i]-1],"R");i++;
		name_state(current,v[id_vec[i]-1],"B");i++;
		name_state(current,v[id_vec[i]-1],"D");i++;
		name_state(current,v[id_vec[i]-1],"R^-1");i++;
		name_state(current,v[id_vec[i]-1],"B^-1");i++;
		name_state(current,v[id_vec[i]-1],"D^-1");i++;
	}
	for(int i=0;i<id_vec.size();i++)
	{
		if(been_to[id_vec[i]-1]== false) 
		{
			current_list.push(id_vec[i]);
			been_to[id_vec[i]-1]= true;
		}
	}
	f << 1 << ',' << v[0].get_name() << endl;
	been_to[0] = true;
	while(current_list.size()!=0)
	{
		current = v[current_list.front()-1];
		current_list.pop();

		to_name = current.get_to();
		f << current.get_id() << ',' << current.get_name() << endl;
		id_vec.clear();
		for(int i=0;i<6;i++)
		{
			id_vec.push_back(to_name[i]);
		}
		for(int i=0;i<id_vec.size();i++)
		{
			name_state(current,v[id_vec[i]-1],"R");i++;
			name_state(current,v[id_vec[i]-1],"B");i++;
			name_state(current,v[id_vec[i]-1],"D");i++;
			name_state(current,v[id_vec[i]-1],"R^-1");i++;
			name_state(current,v[id_vec[i]-1],"B^-1");i++;
			name_state(current,v[id_vec[i]-1],"D^-1");i++;
		}
		for(int i=0;i<id_vec.size();i++)
		{	
			if(been_to[id_vec[i]-1]== false) 
			{
				current_list.push(id_vec[i]);
				been_to[id_vec[i]-1]= true;
			}
		}
	}
	f.close();

	f.open("names.csv");
	for(int i=0;i<3674160;i++)
	{
		f << i << ',' << v[i].get_name() << endl;
	}

	f.close();
}
void name_state(state& s1, state& s2, string str)
{
	if(s2.get_name().empty())
	{
		s2.set_name(s1.get_name() + str);
		s2.set_depth(s1.get_depth()+1);
	}
	else if(s2.get_depth() == s1.get_depth() +1)
	{
		s2.append_name(",");
		s2.append_name(s1.get_name() + str);
	}
}
state::state(){
	id = -1;
	to = new int[6];
	name = nullptr;
}
state::state(int id_n){
	id = id_n;
	to = new int[6];
}
state::~state(){
}
