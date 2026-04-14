module AStarHeuristic (  
    input [7:0] current_cost,  
    input [7:0] estimated_cost,  
    output [7:0] total_estimated_cost  
);  
    assign total_estimated_cost = current_cost + estimated_cost;  
endmodule