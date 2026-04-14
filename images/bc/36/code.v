module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hda30;
      1: q = 16'ha94c;
      2: q = 16'h234d;
      3: q = 16'h8155;
      4: q = 16'h39a4;
      5: q = 16'h3f8a;
      6: q = 16'h24b4;
      7: q = 16'h4717;
    endcase

endmodule
