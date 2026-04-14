module top_module(i_0r0, i_0r1, i_0a, o_0r0, o_0r1, o_0a, reset);input i_0r0;
  input i_0r1;
  output reg i_0a;
  output o_0r0;
  output o_0r1;
  input o_0a;
  input reset;
  wire bna_0;
  wire tech1_oint;
  wire tech2_oint;
  wire bcomp_0;

  // Replace AO222EHD with a combination of standard gates
  assign o_0r0 = (i_0r0 & bna_0) | (tech1_oint & i_0r0) | (tech1_oint & bna_0);
  assign tech1_oint = o_0r0 & ~reset;

  assign o_0r1 = (i_0r1 & bna_0) | (tech2_oint & i_0r1) | (tech2_oint & bna_0);
  assign tech2_oint = o_0r1 & ~reset;

  assign bna_0 = ~o_0a;  // Replacing INVHHD with NOT implementation
  assign bcomp_0 = o_0r0 | o_0r1;  // Replacing OR2EHD with OR implementation

  always @(*) begin
    i_0a = bcomp_0;  // Using always block to drive i_0a
  end
endmodule