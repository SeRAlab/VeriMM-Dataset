module rrt_path_planning(  
    input clk,  
    input reset,  
    input [7:0] start_x,  
    input [7:0] start_y,  
    input [7:0] target_x,  
    input [7:0] target_y,  
    input [7:0] max_iterations,  
    output reg found  
);  
    reg [7:0] current_x, current_y;  
    reg [7:0] random_x, random_y;  
    reg [7:0] iteration_count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_x <= start_x;  
            current_y <= start_y;  
            iteration_count <= 0;  
            found <= 0;  
        end else if (iteration_count < max_iterations) begin  
            // Generate random point (for simplicity, just incrementing here)  
            random_x <= (current_x + 1) % 256;  
            random_y <= (current_y + 1) % 256;  
            
            // Check if we reached the target  
            if ((random_x == target_x) && (random_y == target_y)) begin  
                found <= 1;  
            end  

            // Update current position for the next iteration  
            current_x <= random_x;  
            current_y <= random_y;  
            iteration_count <= iteration_count + 1;  
        end  
    end  
endmodule