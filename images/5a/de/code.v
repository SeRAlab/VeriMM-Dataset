module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h25c8;
      1: q = 16'h9df1;
      2: q = 16'hbbb8;
      3: q = 16'h22be;
      4: q = 16'he86b;
      5: q = 16'hba5c;
      6: q = 16'h9bec;
      7: q = 16'hc36e;
    endcase

endmodule
