module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h5db5;
      1: q = 16'ha7db;
      2: q = 16'hb7c9;
      3: q = 16'h8a47;
      4: q = 16'h483b;
      5: q = 16'h051d;
      6: q = 16'h2915;
      7: q = 16'h4a50;
    endcase

endmodule
