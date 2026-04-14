module top_module( B_in, A_out );input [2:0] B_in;
  output [2:0] A_out;
  wire   N53, N55, N57, n18, n19, n20, n21;

  assign A_out[0] = N53;
  assign A_out[1] = N55;
  assign A_out[2] = N57;

  // Using standard Verilog gates instead
  assign N53 = ~(B_in[0] & B_in[1] & n18) | (n21 & n20 & B_in[2]);
  assign n21 = ~B_in[0];
  assign n18 = ~B_in[2];
  assign n20 = ~B_in[1];
  assign N55 = (B_in[0] & B_in[1]) | n18;
  
  assign N57 = (B_in[1] & n21) | (n20 & B_in[2]) | n19;
  assign n19 = B_in[2] & n21;
  
endmodule