module top_module(din, rst_l, en, clk, q, se, si, so);parameter SIZE = 1;

input [SIZE-1:0] din;
input rst_l;
input en;
input clk;

output [SIZE-1:0] q;

input se;
input [SIZE-1:0] si;
output [SIZE-1:0] so;

reg [SIZE-1:0] q;

always @ (posedge clk) begin
    if (!rst_l) begin
        q <= {SIZE{1'b0}};
    end else if (se) begin
        q <= si;
    end else if (en) begin
        q <= din;
    end
end

assign so = q;

endmodule