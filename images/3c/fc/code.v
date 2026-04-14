module rrt_controller (
    input clk,
    input reset,
    input [3:0] current_x,
    input [3:0] current_y,
    input [3:0] target_x,
    input [3:0] target_y,
    output reg [3:0] next_x,
    output reg [3:0] next_y
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            next_x <= current_x;
            next_y <= current_y;
        end else begin
            if (current_x < target_x) 
                next_x <= current_x + 1;
            else if (current_x > target_x) 
                next_x <= current_x - 1;
            else 
                next_x <= current_x;
                
            if (current_y < target_y) 
                next_y <= current_y + 1;
            else if (current_y > target_y) 
                next_y <= current_y - 1;
            else 
                next_y <= current_y;
        end
    end
endmodule