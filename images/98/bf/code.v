module top_module(input [32-1:0] din, 
                                   input clk, en, rst,
                                   output reg [32-1:0] dout
    );always @(posedge clk)
begin
  if(rst)
  dout <= 0;
  
  else
  if(en)
    dout <= din;
  
end 


endmodule