module AStarSearch (  
    input [4:0] current_node,  
    input [4:0] goal_node,  
    input [4:0] heuristic_value,  
    output reg [4:0] next_node  
);  

    always @(*) begin  
        // Simplified cost function: next_node = current_node + heuristic_value  
        next_node = current_node + heuristic_value;  
        // Ensure next_node does not exceed a predefined maximum value  
        if (next_node > 5'd31)  
            next_node = 5'd31;  
    end  
endmodule