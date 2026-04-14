module top_module(inp, res);parameter signed [31:0] inp_width = 16; 
  parameter signed [31:0] result_width = 16; 
  parameter signed [31:0] shift_value = 8; 
  parameter signed [31:0] shift_dir = 0; 
  parameter signed [31:0] vec_MSB = inp_width - 1; 
  parameter signed [31:0] result_MSB = result_width - 1; 
  parameter signed [31:0] result_LSB = vec_MSB - result_MSB; 
  input [vec_MSB : 0] inp; 
  output [result_MSB : 0] res; 
  wire [vec_MSB:0] vec; 
  genvar i; 
  assign res = vec[vec_MSB:result_LSB]; 
  generate 
  if (shift_dir == 1) 
  begin:left_shift_loop 
  for (i = vec_MSB; i>=0; i = i-1) 
  begin:u0 
  if (i < shift_value) 
  begin:u1 
  assign vec[i] = 1'b0; 
  end 
  else 
  begin:u2 
  assign vec[i] = inp[i-shift_value]; 
  end 
  end 
  end 
  else 
  begin:right_shift_loop 
  for (i = 0; i <= vec_MSB; i = i+1) 
  begin:u3 
  if (i > vec_MSB - shift_value) 
  begin:u4 
  assign vec[i] = inp[vec_MSB]; 
  end 
  else 
  begin:u5 
  assign vec[i] = inp[i+shift_value]; 
  end 
  end 
  end 
  endgenerate 
 endmodule