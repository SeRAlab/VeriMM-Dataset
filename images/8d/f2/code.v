module top_module(RESET_IN, RESET_OUT);input RESET_IN; 
  output RESET_OUT; 
  wire RESET_OUT; 
  assign RESET_OUT = ! RESET_IN ; 
 endmodule