module rrt_path_planner(
    input wire clk,
    input wire reset,
    input wire [7:0] current_x,
    input wire [7:0] current_y,
    input wire [7:0] target_x,
    input wire [7:0] target_y,
    output reg [7:0] new_x,
    output reg [7:0] new_y
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            new_x <= 8'b0;
            new_y <= 8'b0;
        end else begin
            // Simple random step towards the target
            new_x <= current_x + ((target_x - current_x) > 0 ? 1 : -1);
            new_y <= current_y + ((target_y - current_y) > 0 ? 1 : -1);
        end
    end
endmodule