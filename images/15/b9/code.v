module rrt_algorithm (  
    input clk,  
    input reset,  
    input [7:0] start_x,  
    input [7:0] start_y,  
    input [7:0] goal_x,  
    input [7:0] goal_y,  
    output reg [7:0] path_x,  
    output reg [7:0] path_y,  
    output reg path_found  
);  

    reg [7:0] current_x;  
    reg [7:0] current_y;  
    reg [7:0] random_x;  
    reg [7:0] random_y;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_x <= start_x;  
            current_y <= start_y;  
            path_found <= 0;  
        end else begin  
            // Generate random points (for simulation purposes, we will just increment)  
            random_x <= (current_x + 1) % 256;  
            random_y <= (current_y + 1) % 256;  

            // Check if we are close enough to the goal  
            if (((random_x - goal_x) ** 2 + (random_y - goal_y) ** 2) < 16) begin  
                path_found <= 1;  
                path_x <= random_x;  
                path_y <= random_y;  
            end else begin  
                current_x <= random_x;  
                current_y <= random_y;  
            end  
        end  
    end  
endmodule