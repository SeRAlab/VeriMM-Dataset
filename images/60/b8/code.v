module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h76af;
      1: q = 16'h64f7;
      2: q = 16'h381a;
      3: q = 16'hf80e;
      4: q = 16'habd0;
      5: q = 16'h40e8;
      6: q = 16'h4ff9;
      7: q = 16'h903d;
    endcase

endmodule
