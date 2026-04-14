module top_module(ctrl,
    D0,
    D1,
    S);parameter INIT_VALUE = 8'hB8;
  
  input ctrl;
  input [0:0] D0;
  input [0:0] D1;
  output [0:0] S;

  // Removing redundant wire declarations for inputs and output
  // wire [0:0] D0;
  // wire [0:0] D1;
  // wire [0:0] S;
  // wire ctrl;

  assign S = ctrl ? D1 : D0; // Keep the assign statement for the MUX logic

endmodule