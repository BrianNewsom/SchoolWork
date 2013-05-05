#include <cmath>

#include "Edge.h"

using namespace std;
namespace YOUR_NAME_HERE
{
	Edge::Edge(const double& edgeCost)
	{
		cost = edgeCost;
		bad = false;
	}
	
	Edge::Edge( )
	{
		cost = 0.0;
		bad = false;
	}

	Edge::Edge(const Edge& anotherEdge )
	{
		cost = anotherEdge.getCost();
		bad = anotherEdge.getBadness();
	}

	void Edge::setBadness(const bool& badOrNot)
	{
		bad = badOrNot; 
	}
	
	bool Edge::getBadness() const
	{
		return bad;
	}
	
	bool Edge::exists() const
	{
		double epsilon = 0.0000000000000000001;
		return (fabs(cost) > epsilon);
	}
	
	void Edge::setCost(const double& newCost)
	{
		cost = newCost;
	}
	
	void Edge::erase( )
	{
		cost = 0.0;
	}
	
	const double& Edge::getCost( ) const
	{
		return cost;
	}
	
}
