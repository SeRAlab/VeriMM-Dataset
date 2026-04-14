module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hdf2e;
      1: q = 16'h4242;
      2: q = 16'h603f;
      3: q = 16'he227;
      4: q = 16'hcb4c;
      5: q = 16'hbe0a;
      6: q = 16'he576;
      7: q = 16'haddd;
    endcase

endmodule
