module top_module(clk,a,b,c,hold);parameter A_WIDTH = 6 ; 
 parameter B_WIDTH = 6 ; 
 input hold; 
 input clk; 
 input signed [(A_WIDTH - 1):0] a; 
 input signed [(B_WIDTH - 1):0] b; 
 output signed [(A_WIDTH + B_WIDTH - 1):0] c; 
 reg signed [A_WIDTH-1:0] reg_a; 
 reg signed [B_WIDTH-1:0] reg_b; 
 reg [(A_WIDTH + B_WIDTH - 1):0] reg_tmp_c; 
 assign c = reg_tmp_c; 
 always @(posedge clk) 
 begin 
  if (!hold) begin 
  reg_a <= a; 
  reg_b <= b; 
  reg_tmp_c <= reg_a * reg_b + c; 
  end 
 end 
 endmodule