module Multiplexer_AC__parameterized57
   (ctrl,
    D0,
    D1,
    S);
  input ctrl;
  input [0:0]D0;
  input [0:0]D1;
  output [0:0]S;

  wire [0:0]D0;
  wire [0:0]D1;
  wire [0:0]S;
  wire ctrl;

  assign S = ctrl ? D1 : D0;

endmodule