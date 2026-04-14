module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hcff4;
      1: q = 16'h988d;
      2: q = 16'h5a41;
      3: q = 16'h31ab;
      4: q = 16'hed89;
      5: q = 16'h0840;
      6: q = 16'h60a5;
      7: q = 16'h3a49;
    endcase

endmodule
