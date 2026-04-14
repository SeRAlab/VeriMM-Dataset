module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h2f40;
      1: q = 16'hd654;
      2: q = 16'h708a;
      3: q = 16'h04b6;
      4: q = 16'hbabc;
      5: q = 16'h31c3;
      6: q = 16'h11d1;
      7: q = 16'h4881;
    endcase

endmodule
