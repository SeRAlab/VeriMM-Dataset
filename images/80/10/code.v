module lfsr(
    input clk,
    input reset,
    input [11:0] seed,
    output reg [11:0] q);always @(posedge clk) begin
    if (reset)
        q <= seed;
    else
        q <= {q[10:0], q[11] ^ q[1]};
end
endmodule