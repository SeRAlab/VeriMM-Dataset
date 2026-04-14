module top_module(i_0r0, i_0r1, i_0a, o_0r0, o_0r1, reset);input [1:0] i_0r0;
  input [1:0] i_0r1;
  output i_0a;
  output [1:0] o_0r0;
  output [1:0] o_0r1;
  input reset;

  wire bna_0;
  wire tech1_oint;
  wire tech2_oint;
  wire tech3_oint;
  wire tech4_oint;
  wire [1:0] bcomp_0;

  // Inverting reset signal for bna_0
  assign bna_0 = ~reset;

  // Implement the OR operation for o_0r0 and o_0r1
  assign o_0r0[0] = (i_0r0[0] | bna_0) & tech1_oint;
  assign tech1_oint = ~o_0r0[0] | reset;
  
  assign o_0r0[1] = (i_0r0[1] | bna_0) & tech2_oint;
  assign tech2_oint = ~o_0r0[1] | reset;
  
  assign o_0r1[0] = (i_0r1[0] | bna_0) & tech3_oint;
  assign tech3_oint = ~o_0r1[0] | reset;
  
  assign o_0r1[1] = (i_0r1[1] | bna_0) & tech4_oint;
  assign tech4_oint = ~o_0r1[1] | reset;

  // Implement the OR operation for bcomp_0
  assign bcomp_0[0] = o_0r0[0] | o_0r1[0];
  assign bcomp_0[1] = o_0r0[1] | o_0r1[1];

  // Implement the OR operation for i_0a
  assign i_0a = bcomp_0[0] | bcomp_0[1];

endmodule