module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h9448;
      1: q = 16'hcade;
      2: q = 16'hfef3;
      3: q = 16'hba4d;
      4: q = 16'h0e3a;
      5: q = 16'h8968;
      6: q = 16'h606f;
      7: q = 16'h9444;
    endcase

endmodule
