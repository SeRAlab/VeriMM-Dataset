module top_module(input [(16 - 1):0] input_port,output [(16 - 1):0] output_port,input clk,input ce,input clr);wire [(16 - 1):0] input_port_1_40; 
  wire signed [(16 - 1):0] output_port_5_5_force; 
  assign input_port_1_40 = input_port; 
  assign output_port_5_5_force = input_port_1_40; 
  assign output_port = output_port_5_5_force; 
 endmodule