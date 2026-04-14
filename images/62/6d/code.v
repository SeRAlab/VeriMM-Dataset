module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h110c;
      1: q = 16'h46ba;
      2: q = 16'hbd1f;
      3: q = 16'h4f7e;
      4: q = 16'h4de0;
      5: q = 16'hf25e;
      6: q = 16'h054d;
      7: q = 16'hedff;
    endcase

endmodule
