module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hf129;
      1: q = 16'hac0d;
      2: q = 16'h633e;
      3: q = 16'hd434;
      4: q = 16'h7254;
      5: q = 16'ha6e4;
      6: q = 16'h0056;
      7: q = 16'h500d;
    endcase

endmodule
