module top_module(ctrl,
    D0,
    D1,
    S);parameter WIDTH = 128;

  input ctrl;
  input [WIDTH-1:0] D0;
  input [WIDTH-1:0] D1;
  output [WIDTH-1:0] S;

  wire [WIDTH-1:0] S_wire; // Remove unused wires

  // Use a conditional operator to implement the multiplexer functionality
  assign S_wire = (ctrl) ? D1 : D0;

  assign S = S_wire;

endmodule