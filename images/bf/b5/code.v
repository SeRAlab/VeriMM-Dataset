module zzinc64 ( in, out );
  input  [63:0] in;
  output [63:0] out;   
  assign out = in + 1'b1;
endmodule