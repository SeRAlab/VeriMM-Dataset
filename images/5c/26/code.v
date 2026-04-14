module top_module(clk, ce, a, b, p);input clk;
input ce;
input[8 - 1 : 0] a; 
input[24 - 1 : 0] b; 
output[31 - 1 : 0] p;

reg [8 - 1 : 0] a_reg0;
reg [24 - 1 : 0] b_reg0;
wire [31 - 1 : 0] tmp_product;
reg [31 - 1 : 0] buff0;

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