module RRT_Node (
    input clk,
    input reset,
    input [7:0] random_x,
    input [7:0] random_y,
    input [7:0] last_x,
    input [7:0] last_y,
    input [7:0] distance_threshold,
    output reg [7:0] new_x,
    output reg [7:0] new_y,
    output reg valid
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        new_x <= 8'b0;
        new_y <= 8'b0;
        valid <= 1'b0;
    end else begin
        if ((random_x - last_x) ** 2 + (random_y - last_y) ** 2 <= distance_threshold ** 2) begin
            new_x <= random_x;
            new_y <= random_y;
            valid <= 1'b1;
        end else begin
            new_x <= new_x; // retain previous valid point
            new_y <= new_y; // retain previous valid point
            valid <= 1'b0;
        end
    end
end

endmodule