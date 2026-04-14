module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h1205;
      1: q = 16'hdcda;
      2: q = 16'hd68c;
      3: q = 16'h10ac;
      4: q = 16'h94f9;
      5: q = 16'hd920;
      6: q = 16'h9682;
      7: q = 16'h8b4f;
    endcase

endmodule
