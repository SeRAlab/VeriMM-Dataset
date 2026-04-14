module reg64 (
    input clk,
    input reset,
    input [63:0] d,
    output reg [63:0] q);always @(posedge clk) begin
    if (reset)
        q <= 64'b0;
    else
        q <= d;
end
endmodule