module top_module(out1, in1, in2, in3, in4);parameter gate_delay = 1; // Define gate delay parameter

  input in1, in2, in3, in4;
  output out1;

  wire and1, and2, and3;

  and #(gate_delay) and_inst1 (and1, in1, in2);
  and #(gate_delay) and_inst2 (and2, in3, in4);
  and #(gate_delay) and_inst3 (and3, and1, and2);

  assign out1 = and3;

endmodule