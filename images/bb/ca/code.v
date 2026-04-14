module d_flip_flop(
    input wire clk,
    input wire reset,
    input wire enable,
    input wire d,
    output reg q
);

always @(posedge clk or posedge reset) begin
    if (reset)
        q <= 1'b0;
    else if (enable)
        q <= d;
end

endmodule