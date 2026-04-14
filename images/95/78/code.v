module top_module(clk, ce, a, b, p);input clk;
input ce;
input [10 - 1 : 0] a;
input [12 - 1 : 0] b;
output[22 - 1 : 0] p;
reg signed [22 - 1 : 0] p;
wire [22 - 1 : 0] tmp_product;

assign tmp_product = a * b;
always @ (posedge clk) begin
    if (ce) begin
        p <= tmp_product;
    end
end
endmodule