module top_module(clk, ce, a, b, p);input clk;
input ce;
input[8 - 1 : 0] a; 
input[6 - 1 : 0] b; 
output[14 - 1 : 0] p;
reg[8 - 1 : 0] a_reg;
reg[6 - 1 : 0] b_reg;
wire [14 - 1 : 0] tmp_product;
reg[14 - 1 : 0] buff0;
reg[14 - 1 : 0] buff1;

assign p = buff1;
assign tmp_product = a_reg * b_reg;
always @ (posedge clk) begin
    if (ce) begin
        a_reg <= a;
        b_reg <= b;
        buff0 <= tmp_product;
        buff1 <= buff0;
    end
end
endmodule