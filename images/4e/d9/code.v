module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hd827;
      1: q = 16'h6a65;
      2: q = 16'h8db4;
      3: q = 16'ha304;
      4: q = 16'hb1ff;
      5: q = 16'heb65;
      6: q = 16'h2bf0;
      7: q = 16'hfc86;
    endcase

endmodule
