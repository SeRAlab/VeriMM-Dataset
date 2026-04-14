module top_module(din, clk, q, se, si, so);parameter SIZE = 1;

input [SIZE-1:0] din; // data in
input clk; // clk or scan clk
output [SIZE-1:0] q; // output
input se; // scan-enable
input [SIZE-1:0] si; // scan-input
output [SIZE-1:0] so; // scan-output

reg [SIZE-1:0] q;

always @ (posedge clk) begin
    if (se) // scan-enable is high
        q <= si;
    else // scan-enable is low
        q <= din;
end

assign so = q;

endmodule