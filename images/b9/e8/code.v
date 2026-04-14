module top_module(
                 input wire [31 : 0]  y0,
                 input wire [31 : 0]  y1,
                 input wire [31 : 0]  y2,
                 input wire [31 : 0]  y3,

                 output wire [31 : 0] z0,
                 output wire [31 : 0] z1,
                 output wire [31 : 0] z2,
                 output wire [31 : 0] z3
                );//----------------------------------------------------------------
  // Wires.
  //----------------------------------------------------------------
  reg [31 : 0] tmp_z0;
  reg [31 : 0] tmp_z1;
  reg [31 : 0] tmp_z2;
  reg [31 : 0] tmp_z3;

  
  //----------------------------------------------------------------
  // Concurrent connectivity for ports.
  //----------------------------------------------------------------
  assign z0 = tmp_z0;
  assign z1 = tmp_z1;
  assign z2 = tmp_z2;
  assign z3 = tmp_z3;

  
  //----------------------------------------------------------------
  // qr
  //
  // The actual quarterround function.
  //----------------------------------------------------------------
  always @*
    begin : qr
      reg [31 : 0] z0_0;
      reg [31 : 0] z1_0;
      reg [31 : 0] z2_0;
      reg [31 : 0] z3_0;

      z1_0   = (y0 + y3) << 7;
      tmp_z1 = {z1_0[24 : 0], z1_0[31 : 25]} ^ y1;

      z2_0   = (tmp_z1 + y0) << 9;
      tmp_z2 = {z2_0[22 : 0], z2_0[31 : 23]} ^ y2;

      z3_0   = (tmp_z2 + tmp_z1) << 13;
      tmp_z3 = {z3_0[18 : 0], z3_0[31 : 19]} ^ y3;

      z0_0   = (tmp_z3 + tmp_z2) << 18;
      tmp_z0 = {z0_0[13 : 0], z0_0[31 : 14]} ^ y0;
    end // qr
endmodule