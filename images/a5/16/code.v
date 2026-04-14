module top_module(ctrl,
    D0,
    D1,
    S);input ctrl;
  input [0:0]D0;
  input [0:0]D1;
  output [0:0]S;

  wire [0:0]D0_wire;
  wire [0:0]D1_wire;
  wire [0:0]S_wire;
  wire ctrl_wire;

  assign D0_wire = D0;
  assign D1_wire = D1;
  assign ctrl_wire = ctrl;

  // Replace LUT3 with a simple assign statement for a multiplexer
  assign S_wire = (ctrl_wire) ? D1_wire : D0_wire;

  assign S = S_wire;
endmodule