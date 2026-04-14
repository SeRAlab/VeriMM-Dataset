module top_module(input[7:0] INP, input[7:0] INN, input CLK, input PWRDN, output reg GREATER, output reg EQUAL);parameter PWRDN_SYNC = 1'b0; 
  parameter CLK_EDGE = "RISING"; 
  parameter GREATER_OR_EQUAL = 1'b0; 
  initial GREATER = 0; 
  initial EQUAL = 0; 
  wire clk_minv = (CLK_EDGE == "RISING") ? CLK : ~CLK; 
  always @(posedge clk_minv) begin 
  if(GREATER_OR_EQUAL) 
  GREATER <= (INP >= INN); 
  else 
  GREATER <= (INP > INN); 
  EQUAL <= (INP == INN); 
  end 
 endmodule