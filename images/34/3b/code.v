module AStarHeuristic (
    input [3:0] g, // cost from start to current node
    input [3:0] h, // heuristic cost to goal node
    output [3:0] f  // total estimated cost
);
    assign f = g + h; // f = g + h
endmodule