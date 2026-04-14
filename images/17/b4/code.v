module rrt_tree #(parameter POINT_WIDTH = 8) (  
    input clk,  
    input rst,  
    input [POINT_WIDTH-1:0] current_point_x,  
    input [POINT_WIDTH-1:0] current_point_y,  
    input [POINT_WIDTH-1:0] target_point_x,  
    input [POINT_WIDTH-1:0] target_point_y,  
    output reg [POINT_WIDTH-1:0] next_point_x,  
    output reg [POINT_WIDTH-1:0] next_point_y  
);  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            next_point_x <= 0;  
            next_point_y <= 0;  
        end else begin  
            // Simple logic to approach target point  
            if (current_point_x < target_point_x)  
                next_point_x <= current_point_x + 1;  
            else if (current_point_x > target_point_x)  
                next_point_x <= current_point_x - 1;  
            else  
                next_point_x <= current_point_x;  
  
            if (current_point_y < target_point_y)  
                next_point_y <= current_point_y + 1;  
            else if (current_point_y > target_point_y)  
                next_point_y <= current_point_y - 1;  
            else  
                next_point_y <= current_point_y;  
        end  
    end  
endmodule