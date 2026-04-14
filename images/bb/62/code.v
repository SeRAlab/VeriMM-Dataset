module top_module(
  input a,
  input b,
  output out
);parameter gate = "AND"; // type of logic gate to be implemented

  // Implement AND gate
  assign out = (gate == "AND") ? (a & b) :
               // Implement OR gate
               (gate == "OR") ? (a | b) :
               // Implement NOT gate
               (gate == "NOT") ? (!a) :
               // Implement XOR gate
               (gate == "XOR") ? (a ^ b) :
               // Implement XNOR gate
               (gate == "XNOR") ? (!(a ^ b)) :
               // Default to AND gate
               (a & b);

endmodule