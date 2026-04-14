module top_module(clk, ce, a, b, p);input clk;
input ce;
input[31 - 1 : 0] a; // synthesis attribute keep a "true"
input signed [32 - 1 : 0] b; // synthesis attribute keep b "true"
output reg signed [32 - 1 : 0] p;

reg [31 - 1 : 0] a_reg0;
reg signed [32 - 1 : 0] b_reg0;
wire signed [32 - 1 : 0] tmp_product;
reg signed [32 - 1 : 0] buff0;

assign tmp_product = $signed({1'b0, a_reg0}) * b_reg0;
always @ (posedge clk) begin
    if (ce) begin
        a_reg0 <= a;
        b_reg0 <= b;
        buff0 <= tmp_product;
    end
end

always @ (posedge clk) begin
    if (ce) begin
        p <= buff0;
    end
end

endmodule