module top_module( in0, in1, in2, in3, d0, d1, out );input in0, in1, in2, in3, d0, d1;
  output out;
  wire   n1, n2;

  // Implementing MUX functionality directly instead of using MUX2X1
  assign n2 = d0 ? in3 : in2;  // 2-to-1 MUX for the second pair
  assign n1 = d0 ? in1 : in0;  // 2-to-1 MUX for the first pair
  assign out = d1 ? n2 : n1;   // 2-to-1 MUX to select between n1 and n2

endmodule