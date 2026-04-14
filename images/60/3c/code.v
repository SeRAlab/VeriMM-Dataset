module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hcaf7;
      1: q = 16'h3ed1;
      2: q = 16'h0728;
      3: q = 16'hfc57;
      4: q = 16'h0c22;
      5: q = 16'h49ed;
      6: q = 16'h14df;
      7: q = 16'hcbfa;
    endcase

endmodule
