module top_module(input CLK, input CE, input sr_input, output pushPop_out);parameter INSTANCE_NAME="INST"; 
  assign pushPop_out = sr_input; 
 endmodule