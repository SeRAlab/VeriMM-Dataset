module top_module(clk, ce, a, b, p);input clk;
input ce;
input[16 - 1 : 0] a; // synthesis attribute keep a "true"
input[32 - 1 : 0] b; // synthesis attribute keep b "true"
output[48 - 1 : 0] p;

reg [16 - 1 : 0] a_reg0;
reg [32 - 1 : 0] b_reg0;
wire [48 - 1 : 0] tmp_product;
reg [48 - 1 : 0] buff0;

assign p = buff0;
assign tmp_product = a_reg0 * b_reg0;
always @ (posedge clk) begin
    if (ce) begin
        a_reg0 <= a;
        b_reg0 <= b;
        buff0 <= tmp_product;
    end
end
endmodule