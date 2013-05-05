#ifndef CSCI1300_VERTEX_H
#define CSCI1300_VERTEX_H

#include <string>
#include <cstring>

namespace YOUR_NAME_HERE
{
  class Vertex
    {
		public:
	
			Vertex( );
			Vertex(const std::string& vertexName);
			const std::string& getName() const;
			void setName(const std::string& newName);
			bool getBadness();
			void setBadness(const bool& badOrNot);
		
		private:
		
			std::string name;
			bool bad;
    };
}
#endif
