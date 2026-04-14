module top_module(byteenable_in,clk,reset_n,waitrequest_in,write_in,byteenable_out,waitrequest_out);output [ 1: 0] byteenable_out; 
  output waitrequest_out; 
  input [ 1: 0] byteenable_in; 
  input clk; 
  input reset_n; 
  input waitrequest_in; 
  input write_in; 
  wire [ 1: 0] byteenable_out; 
  wire waitrequest_out; 
  assign byteenable_out = byteenable_in & {2{write_in}}; 
  assign waitrequest_out = waitrequest_in | ((write_in == 1) & (waitrequest_in == 1)); 
 endmodule