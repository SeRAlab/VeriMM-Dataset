module AStarSelector(  
    input [3:0] current_node,  
    input [3:0] target_node,  
    input [3:0] heuristic_value,  
    output reg [3:0] next_node  
);  
    always @(*) begin  
        // Simplified logic for selecting the next node
        // Assuming we have 4 nodes (0 to 3) and some arbitrary costs
        // The node with the lowest cost to the target will be selected
        // Here, we consider current_node and add the heuristic for a cost estimate
        case (current_node)  
            4'b0000: next_node = (heuristic_value < 4'b0001) ? 4'b0001 : 4'b0010;  
            4'b0001: next_node = (heuristic_value < 4'b0001) ? 4'b0010 : 4'b0000;  
            4'b0010: next_node = (heuristic_value < 4'b0001) ? 4'b0000 : 4'b0001;  
            default: next_node = 4'b0000;  
        endcase  
    end  
endmodule