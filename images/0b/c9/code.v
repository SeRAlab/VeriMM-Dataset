module rrt_step(
    input wire clk,
    input wire reset,
    input wire [7:0] current_x, 
    input wire [7:0] current_y, 
    input wire [7:0] target_x, 
    input wire [7:0] target_y, 
    input wire [7:0] step_size,
    output reg [7:0] next_x,
    output reg [7:0] next_y
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            next_x <= 8'b0;
            next_y <= 8'b0;
        end else begin
            // Calculate direction towards target
            if (current_x < target_x) 
                next_x <= current_x + (step_size > (target_x - current_x) ? (target_x - current_x) : step_size);
            else if (current_x > target_x) 
                next_x <= current_x - (step_size > (current_x - target_x) ? (current_x - target_x) : step_size);
            else 
                next_x <= current_x;

            if (current_y < target_y) 
                next_y <= current_y + (step_size > (target_y - current_y) ? (target_y - current_y) : step_size);
            else if (current_y > target_y) 
                next_y <= current_y - (step_size > (current_y - target_y) ? (current_y - target_y) : step_size);
            else 
                next_y <= current_y;
        end
    end
endmodule