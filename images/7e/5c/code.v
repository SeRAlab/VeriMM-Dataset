module top_module(input clk,input [7:0] DAC_in,output Audio_out);reg [8:0] DAC_Register; 
  always @(posedge clk) DAC_Register <= DAC_Register[7:0] + DAC_in; 
  assign Audio_out = DAC_Register[8]; 
 endmodule