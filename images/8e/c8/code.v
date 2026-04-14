module top_module(input CLK, input process_CE, input [399:0] process_input, output [399:0] process_output);parameter INSTANCE_NAME="INST"; 
  wire [63:0] unnamedcast3515USEDMULTIPLEcast;assign unnamedcast3515USEDMULTIPLEcast = (process_input[63:0]); 
  wire [335:0] unnamedcast3519USEDMULTIPLEcast;assign unnamedcast3519USEDMULTIPLEcast = (process_input[399:64]); 
  assign process_output = {{({unnamedcast3519USEDMULTIPLEcast[335:168]}),({unnamedcast3515USEDMULTIPLEcast[63:32]})},{({unnamedcast3519USEDMULTIPLEcast[167:0]}),({unnamedcast3515USEDMULTIPLEcast[31:0]})}}; 
 endmodule