module Multiplexer(
    input ctrl,
    input [0:0]D0,
    input [0:0]D1,
    output [0:0]S
);

  wire [0:0]S;

  assign S = ctrl ? D1 : D0;

endmodule