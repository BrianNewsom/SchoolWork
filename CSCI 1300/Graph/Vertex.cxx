#include "Vertex.h"

using namespace std;
namespace YOUR_NAME_HERE
{
	Vertex::Vertex(const string& vertexName)
	{
		name = vertexName;
		bad = false;
	}
	
	Vertex::Vertex( )
	{
		name = "";
		bad = false;
	}

	const string& Vertex::getName() const
	{
		return name;
	}
	
	void Vertex::setName(const string& newName)
	{
		name = newName;
	}

	void Vertex::setBadness(const bool& badOrNot)
	{
		bad = badOrNot;
	}
	
	bool Vertex::getBadness()
	{
		return bad;
	}
	
	
}
