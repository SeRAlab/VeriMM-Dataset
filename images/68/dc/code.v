module top_module(input wire[63:0] din_data,input wire din_last,output wire din_ready,input wire din_valid,output wire[63:0] dout_data,output wire dout_last,input wire dout_ready,output wire dout_valid,output wire[63:0] headers_data,output wire headers_last,input wire headers_ready,output wire headers_valid);assign din_ready = 1'bx; 
  assign dout_data = 64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx; 
  assign dout_last = 1'bx; 
  assign dout_valid = 1'bx; 
  assign headers_data = 64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx; 
  assign headers_last = 1'bx; 
  assign headers_valid = 1'bx; 
 endmodule