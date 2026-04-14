module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h8569;
      1: q = 16'he1b0;
      2: q = 16'hd9e6;
      3: q = 16'h6eb5;
      4: q = 16'hd87d;
      5: q = 16'hc34f;
      6: q = 16'h92fc;
      7: q = 16'hdf6f;
    endcase

endmodule
