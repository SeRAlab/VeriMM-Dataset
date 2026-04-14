module logic_gates (
  input a,
  input b,
  output c
);

// AND gate
and gate_and (a, b, c);

// OR gate
or gate_or (a, b, c);

// NOT gate
not gate_not (a, c);

// XOR gate
xor gate_xor (a, b, c);

// XNOR gate
xnor gate_xnor (a, b, c);

endmodule