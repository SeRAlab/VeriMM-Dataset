module top_module(clk, ce, a, b, p);input clk;
input ce;
input[16 - 1 : 0] a; 
input[8 - 1 : 0] b; 
output[24 - 1 : 0] p;
reg[16 - 1 : 0] a_reg;
reg[8 - 1 : 0] b_reg;
wire [24 - 1 : 0] tmp_product;
reg[24 - 1 : 0] buff0;
reg[24 - 1 : 0] buff1;
reg[24 - 1 : 0] buff2;
reg[24 - 1 : 0] buff3;
reg[24 - 1 : 0] buff4;
reg[24 - 1 : 0] buff5;
reg[24 - 1 : 0] buff6;

assign p = buff6;
assign tmp_product = a_reg * b_reg;
always @ (posedge clk) begin
    if (ce) begin
        a_reg <= a;
        b_reg <= b;
        buff0 <= tmp_product;
        buff1 <= buff0;
        buff2 <= buff1;
        buff3 <= buff2;
        buff4 <= buff3;
        buff5 <= buff4;
        buff6 <= buff5;
    end
end
endmodule