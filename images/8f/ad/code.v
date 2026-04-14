module top_module(in, out);input [3:0] in;
  output out;
  
  // local
  wire zero_found;
  assign zero_found = |in; // OR reduction

  // out
  assign out = ~zero_found;
endmodule