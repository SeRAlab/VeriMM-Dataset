module Multiplexer_AC__parameterized65
   (ctrl,
    D0,
    D1,
    S);
  input ctrl;
  input [0:0]D0;
  input [0:0]D1;
  output [0:0]S;

  wire [0:0]S;

  assign S = ctrl ? D1 : D0;
endmodule