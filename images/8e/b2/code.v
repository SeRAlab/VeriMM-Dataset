module top_module(clk, clkcnt_reset, div_500k);input clk; 
  input clkcnt_reset; 
  output div_500k; 
  reg div_500k; 
  reg [19:0] cnt; 
  always @(negedge clkcnt_reset or posedge clk)begin 
  if(~clkcnt_reset) cnt <= 0; 
  else if (cnt >= 500000) begin 
  div_500k <= 0; 
  cnt <= 0; end 
  else if (cnt < 250000) begin 
  div_500k <= 0; 
  cnt <= cnt + 1; end 
  else if ((cnt >= 250000) && (cnt < 500000)) begin 
  div_500k <= 1; 
  cnt <= cnt + 1; end 
  end 
 endmodule