module top_module(input CLK, input process_CE, input [15:0] inp, output [7:0] process_output);parameter INSTANCE_NAME="INST"; 
  assign process_output = ({inp[7:0]}); 
 endmodule