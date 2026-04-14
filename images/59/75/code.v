module top_module(IN_PTC, IN_ORTERM, OUT);parameter INVERT_OUT = 0; 
  input IN_PTC; 
  input IN_ORTERM; 
  output wire OUT; 
  wire xor_intermed; 
  assign OUT = INVERT_OUT ? ~xor_intermed : xor_intermed; 
  assign xor_intermed = IN_ORTERM ^ IN_PTC; 
 endmodule