module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h0d40;
      1: q = 16'h9d90;
      2: q = 16'hac5d;
      3: q = 16'h1b8d;
      4: q = 16'hdfb5;
      5: q = 16'h70db;
      6: q = 16'h32a6;
      7: q = 16'h4862;
    endcase

endmodule
