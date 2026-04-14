module zzinc48 ( in, out, overflow );
  input  [47:0] in;
  output [47:0] out;      
  output        overflow; 
  assign out      = in + 1'b1;
  assign overflow = ~in[47] & out[47];
endmodule