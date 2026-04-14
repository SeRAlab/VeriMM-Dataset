module top_module(data_in, data_out);parameter width = 32; 
  parameter count = 2; 
  input [0:width-1] data_in; 
  output [0:count*width-1] data_out; 
  wire [0:count*width-1] data_out; 
  generate 
  genvar idx; 
  for(idx = 0; idx < width; idx = idx + 1) 
  begin:idxs 
  assign data_out[idx*count:(idx+1)*count-1] = {count{data_in[idx]}}; 
  end 
  endgenerate 
 endmodule