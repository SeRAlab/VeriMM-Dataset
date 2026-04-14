module top_module(ctrl,
    D0,
    D1,
    S);input ctrl;
  input [0:0]D0;
  input [0:0]D1;
  output [0:0]S;

  // Remove unnecessary wire declarations for inputs and output
  // wire [0:0]D0; // not needed, already declared as input
  // wire [0:0]D1; // not needed, already declared as input
  // wire [0:0]S;  // not needed, already declared as output
  // wire ctrl;    // not needed, already declared as input

  // Implement a standard multiplexer instead of using LUT3
  assign S = (ctrl) ? D1 : D0; // Standard 2-to-1 multiplexer logic

endmodule