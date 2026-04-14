module AStarHeuristic (  
    input [7:0] current_cost,  
    input [7:0] heuristic_cost,  
    output [7:0] total_cost  
);  
    assign total_cost = current_cost + heuristic_cost;  
endmodule