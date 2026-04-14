module top_module(
input   wire  sel,
input   wire  clk_0, 
input   wire  clk_1,
output  wire  clk_out
);assign clk_out =  (clk_1 && sel) || (clk_0 && (!sel)) || (clk_1 && clk_0);
   


   
endmodule