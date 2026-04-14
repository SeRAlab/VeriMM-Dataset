module astar_heuristic (  
    input [4:0] x1,  // Current node x-coordinate  
    input [4:0] y1,  // Current node y-coordinate  
    input [4:0] x2,  // Goal node x-coordinate  
    input [4:0] y2,  // Goal node y-coordinate  
    output [5:0] heuristic_cost  // Estimated cost (Manhattan distance)  
);  
    assign heuristic_cost = (x1 > x2 ? (x1 - x2) : (x2 - x1)) + (y1 > y2 ? (y1 - y2) : (y2 - y1));  
endmodule