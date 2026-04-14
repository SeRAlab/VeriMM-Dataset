module AStarSearch(input clk,  
                   input reset,  
                   input [3:0] current_state,  
                   input [3:0] target_state,  
                   output reg [3:0] next_state);  

    reg [3:0] cost_to_reach;  
    reg [3:0] heuristic_cost;  
    reg [3:0] estimated_cost;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            next_state <= 4'b0000;  
        end else begin  
            // Example cost to reach current state (could be from a cost table)  
            cost_to_reach <= current_state;  
            // Example heuristic cost (could be a simple distance calculation)  
            heuristic_cost <= target_state - current_state;  
            // Calculate estimated cost  
            estimated_cost <= cost_to_reach + heuristic_cost;  
            // For simplicity, we'll assume the next state is the one with the lowest estimated cost  
            next_state <= estimated_cost;  
        end  
    end  
endmodule