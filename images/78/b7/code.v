module top_module(clk_div_by14,clk_div_by15, clk);input clk;
output clk_div_by14,clk_div_by15;

reg [14:0] num;
wire [14:0] next_num;

always@(posedge clk)
 begin
  num <= next_num;
 end
assign next_num = num +1'b1;
assign clk_div_by14 = num[14];
assign clk_div_by15 = num[14];

endmodule