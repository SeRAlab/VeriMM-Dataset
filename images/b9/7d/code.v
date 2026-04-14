module top_module(dataa, datab, overflow, result);input [31:0] dataa; 
  input [31:0] datab; 
  output overflow; 
  output [31:0] result; 
  wire [32:0]computation; 
  assign computation = dataa + datab; 
  assign overflow = computation[32]; 
  assign result = computation[31:0]; 
 endmodule