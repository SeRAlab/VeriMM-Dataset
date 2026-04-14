module top_module(data_in, data_out);parameter width = 8; 
  parameter num_blocks = 2; 
  localparam step = width / num_blocks; 
  input [0:width-1] data_in; 
  output [0:width-1] data_out; 
  wire [0:width-1] data_out; 
  generate 
  genvar i; 
  for(i = 0; i < step; i = i + 1) 
  begin:blocks 
  genvar j; 
  for(j = 0; j < num_blocks; j = j + 1) 
  begin:bits 
  assign data_out[i*num_blocks+j] = data_in[i+j*step]; 
  end 
  end 
  endgenerate 
 endmodule