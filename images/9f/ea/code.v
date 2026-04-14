module top_module(input CLK, input process_CE, input [23:0] inp, output [31:0] process_output);parameter INSTANCE_NAME="INST";
  assign process_output = {(8'd0),({inp[23:16]}),({inp[15:8]}),({inp[7:0]})};
  
endmodule