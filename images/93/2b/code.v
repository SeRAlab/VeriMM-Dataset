module top_module(
    direction,
    shiftin,
    shiftby,
    shiftout
);input direction;
input signed [25:0] shiftin;
input [4:0] shiftby;
output reg signed [25:0] shiftout;

always @(*) begin
    if (direction == 1) begin
        shiftout = shiftin >>> shiftby;
    end else begin
        shiftout = shiftin << shiftby;
    end
end

endmodule