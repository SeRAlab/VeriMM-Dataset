module rrt_tree(input clk,  
                 input rst,  
                 input [7:0] random_x,  
                 input [7:0] random_y,  
                 input [7:0] nearest_x,  
                 input [7:0] nearest_y,  
                 input [7:0] threshold,  
                 output reg [7:0] new_x,  
                 output reg [7:0] new_y,  
                 output reg connected);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            new_x <= 8'd0;  
            new_y <= 8'd0;  
            connected <= 1'b0;  
        end else begin  
            if ((random_x - nearest_x) * (random_x - nearest_x) + (random_y - nearest_y) * (random_y - nearest_y) <= threshold * threshold) begin  
                new_x <= random_x;  
                new_y <= random_y;  
                connected <= 1'b1;  
            end else begin  
                new_x <= nearest_x;  
                new_y <= nearest_y;  
                connected <= 1'b0;  
            end  
        end  
    end  
endmodule