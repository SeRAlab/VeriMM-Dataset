module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h02d0;
      1: q = 16'h5b7e;
      2: q = 16'h8208;
      3: q = 16'hcb75;
      4: q = 16'h0901;
      5: q = 16'h7301;
      6: q = 16'h40be;
      7: q = 16'ha1bc;
    endcase

endmodule
