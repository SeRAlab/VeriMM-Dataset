module AStarSearch(input clk,  
                   input reset,  
                   input [3:0] current_state,  
                   input [3:0] goal_state,  
                   output reg [3:0] next_state);  

    reg [3:0] open_list [0:15];  
    reg [3:0] closed_list [0:15];  
    reg [3:0] count_open;  
    reg [3:0] count_closed;  

    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count_open <= 0;  
            count_closed <= 0;  
            next_state <= current_state;  
        end else begin  
            // Simple A* search logic to find next state  
            if (current_state != goal_state) begin  
                open_list[count_open] <= current_state;  
                count_open <= count_open + 1;  
                // Here we would normally calculate the next state based on the heuristic  
                
                // For demo, just simulate moving towards the goal state  
                if (current_state < goal_state)  
                    next_state <= current_state + 1;  
                else if (current_state > goal_state)  
                    next_state <= current_state - 1;  
                else  
                    next_state <= current_state;  
            end else begin  
                next_state <= goal_state;  
            end  
        end  
    end  
endmodule