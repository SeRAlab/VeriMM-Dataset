module top_module(
                 input wire [63 : 0]  a,
                 input wire [63 : 0]  b,
                 input wire [63 : 0]  c,
                 input wire [63 : 0]  d,

                 output wire [63 : 0] a_prim,
                 output wire [63 : 0] b_prim,
                 output wire [63 : 0] c_prim,
                 output wire [63 : 0] d_prim
                );//----------------------------------------------------------------
  // Wires.
  //----------------------------------------------------------------
  reg [63 : 0] internal_a_prim;
  reg [63 : 0] internal_b_prim;
  reg [63 : 0] internal_c_prim;
  reg [63 : 0] internal_d_prim;


  //----------------------------------------------------------------
  // Concurrent connectivity for ports.
  //----------------------------------------------------------------
  assign a_prim = internal_a_prim;
  assign b_prim = internal_b_prim;
  assign c_prim = internal_c_prim;
  assign d_prim = internal_d_prim;


  //----------------------------------------------------------------
  // qr
  //
  // The actual quarterround function.
  //----------------------------------------------------------------
  always @*
    begin : qr
      reg [63 : 0] a0;
      reg [63 : 0] a1;
      reg [63 : 0] b0;
      reg [63 : 0] b1;
      reg [63 : 0] b2;
      reg [63 : 0] b3;
      reg [63 : 0] c0;
      reg [63 : 0] c1;
      reg [63 : 0] d0;
      reg [63 : 0] d1;
      reg [63 : 0] d2;
      reg [63 : 0] d3;

      a0 = a + b;
      d0 = d ^ a0;
      d1 = {d0[15 : 0], d0[31 : 16]};
      c0 = c + d1;
      b0 = b ^ c0;
      b1 = {b0[19 : 0], b0[31 : 20]};
      a1 = a0 + b1;
      d2 = d1 ^ a1;
      d3 = {d2[23 : 0], d2[31 : 24]};
      c1 = c0 + d3;
      b2 = b1 ^ c1;
      b3 = {b2[24 : 0], b2[31 : 25]};

      internal_a_prim = a1;
      internal_b_prim = b3;
      internal_c_prim = c1;
      internal_d_prim = d3;
    end // qr
endmodule