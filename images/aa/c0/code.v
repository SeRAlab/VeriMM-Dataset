module top_module(
  input in1,
  input in2,
  output out
);// AND gate
and gate_and(out, in1, in2);

// OR gate
or gate_or(out, in1, in2);

// NOT gate
not gate_not(out, in1);

// XOR gate
xor gate_xor(out, in1, in2);

// XNOR gate
xnor gate_xnor(out, in1, in2);

endmodule