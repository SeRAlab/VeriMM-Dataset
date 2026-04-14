module top_module(
  input in1,
  input in2,
  output out
);parameter op = 0; // 0 = AND, 1 = OR, 2 = XOR, 3 = NOT. Default is AND.

  // Define the Boolean functions for the four bitwise logical operators
  assign out = (op == 0) ? in1 & in2 :
               (op == 1) ? in1 | in2 :
               (op == 2) ? in1 ^ in2 :
               ~in1; // If op is NOT, ignore in2 and perform NOT operation on in1

endmodule