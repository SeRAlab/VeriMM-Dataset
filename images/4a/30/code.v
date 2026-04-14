module top_module(clk,fixed_num,rounded_num);parameter num_width = 42; 
  parameter fixed_pos = 16; 
  input clk; 
  input [num_width - 1 : 0] fixed_num; 
  output [num_width - fixed_pos - 1 : 0] rounded_num; 
  reg [num_width - fixed_pos - 1 : 0] reg_rounded_num; 
  assign rounded_num = reg_rounded_num; 
  always @(posedge clk) 
  reg_rounded_num <= fixed_num[fixed_pos - 1] == 0 ? 
  fixed_num[num_width -1 : fixed_pos] : 
  fixed_num[num_width -1 : fixed_pos] + 1; 
 endmodule