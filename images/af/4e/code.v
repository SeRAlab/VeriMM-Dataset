module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h5b73;
      1: q = 16'h9c07;
      2: q = 16'hc8d7;
      3: q = 16'h6152;
      4: q = 16'h70de;
      5: q = 16'hdb2b;
      6: q = 16'h06dc;
      7: q = 16'h8b13;
    endcase

endmodule
