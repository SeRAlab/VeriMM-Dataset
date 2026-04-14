module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hdf7f;
      1: q = 16'hfea6;
      2: q = 16'hf68a;
      3: q = 16'hd893;
      4: q = 16'ha3fc;
      5: q = 16'hc546;
      6: q = 16'h39f4;
      7: q = 16'h5dd4;
    endcase

endmodule
