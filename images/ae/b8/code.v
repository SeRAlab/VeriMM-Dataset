module top_module(
    input clk,
    input reset,
    output reg [3:0] q);always @(posedge clk) begin
    if (reset)
        q <= 4'b0001; // Initial value is non-zero
    else
        q <= {q[2:0], q[3] ^ q[2]};
end
endmodule