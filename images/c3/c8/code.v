module digital_circuit(
  input wire in1,
  input wire [1:0] in2,
  input wire [3:0] in3,
  input wire [8:0] in4,
  output wire [15:0] out
);

  assign out = in1 ? (in2 & in3) : (in2 | in4);

endmodule