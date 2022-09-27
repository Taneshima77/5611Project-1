//You will only be turning in this file
//Your solution will be graded based on it's runtime (smaller is better), 
//the optimality of the path you return (shorter is better), and the
//number of collisions along the path (it should be 0 in all cases).

//You must provide a function with the following prototype:
// ArrayList<Integer> planPath(Vec2 startPos, Vec2 goalPos, Vec2[] centers, float[] radii, int numObstacles, Vec2[] nodePos, int numNodes);
// Where: 
//    -startPos and goalPos are 2D start and goal positions
//    -centers and radii are arrays specifying the center and radius of obstacles
//    -numObstacles specifies the number of obstacles
//    -nodePos is an array specifying the 2D position of roadmap nodes
//    -numNodes specifies the number of nodes in the PRM
// The function should return an ArrayList of node IDs (indexes into the nodePos array).
// This should provide a collision-free chain of direct paths from the start position
// to the position of each node, and finally to the goal position.
// If there is no collision-free path between the start and goal, return an ArrayList with
// the 0'th element of "-1".

// Your code can safely make the following assumptions:
//   - The function connectNeighbors() will always be called before planPath()
//   - The variable maxNumNodes has been defined as a large static int, and it will
//     always be bigger than the numNodes variable passed into planPath()
//   - None of the positions in the nodePos array will ever be inside an obstacle
//   - The start and the goal position will never be inside an obstacle

// There are many useful functions in CollisionLibrary.pde and Vec2.pde
// which you can draw on in your implementation. Please add any additional 
// functionality you need to this file (PRM.pde) for compatabilty reasons.

// Here we provide a simple PRM implementation to get you started.
// Be warned, this version has several important limitations.
// For example, it uses BFS which will not provide the shortest path.
// Also, it (wrongly) assumes the nodes closest to the start and goal
// are the best nodes to start/end on your path on. Be sure to fix 
// these and other issues as you work on this assignment. This file is
// intended to illustrate the basic set-up for the assignmtent, don't assume 
// this example funcationality is correct and end up copying it's mistakes!).



//Here, we represent our graph structure as a neighbor list
//You can use any graph representation you like
ArrayList<Integer>[] neighbors = new ArrayList[maxNumNodes];  //A list of neighbors can can be reached from a given node
//We also want some help arrays to keep track of some information about nodes we've visited
Boolean[] visited = new Boolean[maxNumNodes]; //A list which store if a given node has been visited
int[] parent = new int[maxNumNodes]; //A list which stores the best previous node on the optimal path to reach this node

void generateRandomNodesGoalCentric(Vec2[] nodePos, int numNodes){
    int i = 0;
    //for(; i < numNodes/2; i++){
    //  Vec2 randPos = new Vec2(random(width),random(height));
    //  Vec2 ptoG = stoG.times(dot(randPos.minus(startPos),stoG));
    //  ptoG.add(startPos);
    //  ptoG.subtract(randPos);
    //  randPos.add(new Vec2(random(ptoG.x/2)+ptoG.x/4,random(ptoG.y/2)+ptoG.y/4));
    //  boolean insideAnyCircle = pointInCircleList(circleCenters,circleRadii,numObstacles,randPos,startAgentRadius);
    //  while (insideAnyCircle){
    //    randPos = new Vec2(random(width),random(height));
    //    ptoG = stoG.times(dot(randPos.minus(startPos),stoG));
    //    ptoG.add(startPos);
    //    ptoG.subtract(randPos);
    //    randPos.add(new Vec2(random(ptoG.x/2)+ptoG.x/4,random(ptoG.y/2)+ptoG.y/4));
    //    //randPos.add(new Vec2(random(ptoG.x)+ptoG.x/2,random(ptoG.y)+ptoG.y/2));
    //    insideAnyCircle = pointInCircleList(circleCenters,circleRadii,numObstacles,randPos,startAgentRadius);
    //  }
    //  nodePos[i] = randPos;
    //}
    for (; i < numNodes; i++){
      Vec2 randPos = new Vec2(random(width),random(height));
      boolean insideAnyCircle = allObstacles.pointInCircleList(randPos,startAgentRadius);
      while (insideAnyCircle){
        randPos = new Vec2(random(width),random(height));
        insideAnyCircle = allObstacles.pointInCircleList(randPos,startAgentRadius);
      }
      nodePos[i] = randPos;
    }
    
    for(int j = 0; j < agentList.size(); i++,j++){
       nodePos[i] = agentList.get(j).goal; 
    }

}

//void connectNewPoint( Vec2[] nodePos, int numNodes, Vec2 newPoint, int newIndex){
//    neighbors[newIndex] = new ArrayList<Integer>();
//    for (int i = 0; i < numNodes; i++){
//      Vec2 dir = newPoint.minus(nodePos[i]).normalized();
//      float distBetween = nodePos[i].distanceTo(newPoint);
//      hitInfo circleListCheck = allObstacles.rayCircleListIntersect( nodePos[i], dir, distBetween, startAgentRadius);
//      //hitInfo boxListCheck = rayBoxesListIntersect(boxTopLefts,boxW,boxH,nodePos[i],dir,distBetween);
//      if (!circleListCheck.hit && distBetween < 200){
//        neighbors[i].add(newIndex);
//        neighbors[newIndex].add(i);
//      }
//  }
  
//}

//void connectNewPointstoNeighbor(Vec2[] centers, float []radii, int numObstacles, Vec2[] nodePos, int numNodes, Vec2 newPoint, int newIndex){
//  neighbors[newIndex] = new ArrayList<Integer>();  //Clear neighbors list
//  for (int i = 0; i < numNodes; i++){
//    Vec2 dir = nodePos[i].minus(newPoint).normalized();
//    float distBetween = nodePos[i].distanceTo(newPoint);
//    hitInfo circleListCheck = rayCircleListIntersect(centers, radii, numObstacles, nodePos[i], dir, distBetween, startAgentRadius);
//    //hitInfo boxListCheck = rayBoxesListIntersect(boxTopLefts,boxW,boxH,nodePos[i],dir,distBetween);
//    if (!circleListCheck.hit && distBetween < 200){
//      neighbors[newIndex].add(i);
//    }
//  }
//  Vec2 dir = nodePos[numAgents+numNodes].minus(newPoint).normalized();
//  float distBetween = nodePos[numAgents+numNodes].distanceTo(newPoint);
//  hitInfo circleListCheck = rayCircleListIntersect(centers, radii, numObstacles, nodePos[numAgents+numNodes], dir, distBetween, startAgentRadius);
//  //hitInfo boxListCheck = rayBoxesListIntersect(boxTopLefts,boxW,boxH,nodePos[i],dir,distBetween);
//  if (!circleListCheck.hit && distBetween < 200){
//    neighbors[newIndex].add(numAgents+numNodes);
//  }
//}

//Set which nodes are connected to which neighbors (graph edges) based on PRM rules
void connectNeighbors( Vec2[] nodePos, int numNodes){
    for(int j = 0; j < agentList.size(); j++){
       nodePos[j + numNodes] = agentList.get(j).goal; 
    }
    for (int i = 0; i < numNodes + agentList.size(); i++){
        neighbors[i] = new ArrayList<Integer>();  //Clear neighbors list
        for (int j = 0; j < numNodes + agentList.size(); j++){
          
            if (i == j) continue; //don't connect to myself 
      
            Vec2 dir = nodePos[j].minus(nodePos[i]).normalized();
            float distBetween = nodePos[i].distanceTo(nodePos[j]);
            hitInfo circleListCheck = allObstacles.rayCircleListIntersect(nodePos[i], dir, distBetween, startAgentRadius);
            //hitInfo boxListCheck = rayBoxesListIntersect(boxTopLefts,boxW,boxH,nodePos[i],dir,distBetween);
            if (!circleListCheck.hit && distBetween < 200){
                neighbors[i].add(j);
            }
        }
    }
    //setup agents' neighbor
    for(int i = 0; i < agentList.size(); i++){
         for(int j = 0; j < numNodes; j++){
              Vec2 dir = nodePos[j].minus(agentList.get(i).pos).normalized();
              float distBetween = agentList.get(i).pos.distanceTo(nodePos[j]);
              hitInfo circleListCheck = allObstacles.rayCircleListIntersect(agentList.get(i).pos, dir, distBetween, startAgentRadius);
              if (!circleListCheck.hit && distBetween < 200){
                   agentList.get(i).neighbors.add(j);
              }
         }
    }
    
    //connect goal to agents
    for(int i = 0; i < agentList.size(); i++){
          Vec2 dir = agentList.get(i).goal.minus(agentList.get(i).pos).normalized();
          float distBetween = agentList.get(i).pos.distanceTo(agentList.get(i).goal);
          hitInfo circleListCheck = allObstacles.rayCircleListIntersect(agentList.get(i).pos, dir, distBetween, startAgentRadius);
          if (!circleListCheck.hit && distBetween < 200){
               agentList.get(i).neighbors.add(agentList.get(i).goalIndex);
          }
    }
}

//This is probably a bad idea and you shouldn't use it...
int closestNode(Vec2 point, Vec2[] nodePos, int numNodes){
  int closestID = -1;
  float minDist = 999999;
  for (int i = 0; i < numNodes; i++){
    float dist = nodePos[i].distanceTo(point);
    if (dist < minDist){ //<>//
      closestID = i;
      minDist = dist;
    }
  }
  return closestID;
}
//ArrayList<Integer> planPathOne(int numNodes, int agentIndex){
//  ArrayList<Integer> path = new ArrayList();
  
//  path = runBFS(numNodes,numNodes + agentIndex,agentList.size()+numNodes);
//  println(path);
//  return path;
//}
void planPath(int numNodes){
  for(int i = 0; i < agentList.size(); i++){
    agentList.get(i).path = runBFS(numNodes,i,agentList.get(i).goalIndex);
    println(agentList.get(i).path);
    agentList.get(i).pathIndex = 0;
  }
}

//BFS (Breadth First Search)
ArrayList<Vec2> runBFS(int numNodes, int agentID, int goalID){
  ArrayList<Integer> fringe = new ArrayList();  //New empty fringe
  ArrayList<Vec2> path = new ArrayList();
  for (int i = 0; i < numNodes+ agentList.size(); i++) { //Clear visit tags and parent pointers
    visited[i] = false;
    parent[i] = -1; //No parent yet
  }

  //println("\nBeginning Search");
  parent[999] = -1;
  ArrayList<Integer> agentNeighbor = agentList.get(agentID).neighbors;
  for(int i = 0; i < agentNeighbor.size();i++){
      fringe.add(agentNeighbor.get(i));
      visited[agentNeighbor.get(i)] = true;
      parent[i] = 999;
  }
  
  //println("Adding node", startID, "(start) to the fringe.");
  //println(" Current Fringe: ", fringe);
  
  while (fringe.size() > 0){
    int currentNode = fringe.get(0);
    fringe.remove(0);
    if (currentNode == goalID){
      //println("Goal found!");
      break;
    }
    for (int i = 0; i < neighbors[currentNode].size(); i++){
      int neighborNode = neighbors[currentNode].get(i);
      if (!visited[neighborNode]){
        visited[neighborNode] = true;
        parent[neighborNode] = currentNode;
        fringe.add(neighborNode);
        //println("Added node", neighborNode, "to the fringe.");
        //println(" Current Fringe: ", fringe);
      }
    } 
  }
  
  if (fringe.size() == 0){
    //println("No Path");
    path.add(new Vec2(-1,-1));
    return path;
  }
  print("\nReverse path: ");
  int prevNode = parent[goalID];
  path.add(nodePos[goalID]);
  while (prevNode >= 0){
    //print(prevNode," ");
    if(nodePos[prevNode] != null){
        path.add(nodePos[prevNode]);
    }
    
    prevNode = parent[prevNode];
  }
  print("\n");
  Collections.reverse(path);
  return path;
}
