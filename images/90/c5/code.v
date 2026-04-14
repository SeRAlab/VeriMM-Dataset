module top_module(rst_n, clk, clr, sum);input rst_n, clk, clr; 
 output reg [31:0] sum; 
 reg lastClr; 
 always @(negedge rst_n or posedge clk) 
 begin 
  if (~rst_n) 
  begin 
  sum <= 32'b0; 
  lastClr <= 1'b0; 
  end 
  else 
  if (clr && lastClr == ~clr) 
  begin 
  sum <= 32'b0; 
  lastClr <= clr; 
  end 
  else 
  begin 
  sum <= sum + 32'b1; 
  lastClr <= clr; 
  end 
 end 
 endmodule