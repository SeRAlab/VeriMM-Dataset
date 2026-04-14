module top_module(clk, ce, a, b, p);input clk;
input ce;
input[29 - 1 : 0] a; 
input[28 - 1 : 0] b; 
output[47 - 1 : 0] p;

reg signed [29 - 1 : 0] a_reg0;
reg [28 - 1 : 0] b_reg0;
wire signed [47 - 1 : 0] tmp_product;
reg signed [47 - 1 : 0] buff0;

assign p = buff0;
assign tmp_product = a_reg0 * $signed({1'b0, b_reg0});
always @ (posedge clk) begin
    if (ce) begin
        a_reg0 <= a;
        b_reg0 <= b;
        buff0 <= tmp_product;
    end
end
endmodule