module top_module(din, en, clk, q);parameter SIZE = 1;

input [SIZE-1:0] din;
input en, clk;
output [SIZE-1:0] q;

reg [SIZE-1:0] q;

always @(posedge clk) begin
    if (en) begin
        q <= din;
    end
end

endmodule