module slam_system (
    input clk,
    input reset,
    input move_up,
    input move_down,
    input move_left,
    input move_right,
    output reg [7:0] x,
    output reg [7:0] y
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        x <= 8'b0;
        y <= 8'b0;
    end else begin
        if (move_up) y <= y + 1;
        if (move_down) y <= y - 1;
        if (move_left) x <= x - 1;
        if (move_right) x <= x + 1;
    end
end

endmodule