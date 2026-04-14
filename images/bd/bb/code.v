module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hde44;
      1: q = 16'h1962;
      2: q = 16'h5b68;
      3: q = 16'h1c0f;
      4: q = 16'hac80;
      5: q = 16'h2996;
      6: q = 16'h087c;
      7: q = 16'hb975;
    endcase

endmodule
