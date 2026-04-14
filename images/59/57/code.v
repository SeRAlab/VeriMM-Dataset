module top_module(in, clr, out);input in, clr;
  output out;
  
  wire in, clr, out;
  wire qx;
  
  assign qx = out | in;
  assign out = qx & ~clr;
endmodule