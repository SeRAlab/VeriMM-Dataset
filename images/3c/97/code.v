module RRT (
    input clk,
    input reset,
    input [7:0] x,
    input [7:0] y,
    input [7:0] target_x,
    input [7:0] target_y,
    input [7:0] step_size,
    output reg [7:0] next_x,
    output reg [7:0] next_y,
    output reg state // 0: moving, 1: reached
);
    reg [7:0] delta_x;
    reg [7:0] delta_y;
    reg [7:0] distance;
    reg [7:0] step_direction_x;
    reg [7:0] step_direction_y;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            next_x <= 0;
            next_y <= 0;
            state <= 0;
        end else begin
            delta_x <= target_x - x;
            delta_y <= target_y - y;
            distance <= (delta_x * delta_x + delta_y * delta_y) ** 0.5;

            if (distance <= step_size) begin
                next_x <= target_x;
                next_y <= target_y;
                state <= 1; // reached
            end else begin
                step_direction_x <= (delta_x * step_size) / distance;
                step_direction_y <= (delta_y * step_size) / distance;
                next_x <= x + step_direction_x;
                next_y <= y + step_direction_y;
                state <= 0; // moving
            end
        end
    end
endmodule