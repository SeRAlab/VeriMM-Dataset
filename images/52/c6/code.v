module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h0392;
      1: q = 16'hdc84;
      2: q = 16'h8ee3;
      3: q = 16'h78e1;
      4: q = 16'h7f4a;
      5: q = 16'hbc18;
      6: q = 16'h8f4a;
      7: q = 16'h8089;
    endcase

endmodule
