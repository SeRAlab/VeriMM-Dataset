module Span12Mux_v11(I, O);
  input [11:0] I;
  output O;
  
  assign O = I[11] ? I[10] : I[11];
endmodule