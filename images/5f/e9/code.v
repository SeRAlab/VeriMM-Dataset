module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'hdf85;
      1: q = 16'h3163;
      2: q = 16'h6c1b;
      3: q = 16'h0746;
      4: q = 16'h7759;
      5: q = 16'hf3de;
      6: q = 16'h4ded;
      7: q = 16'h7e51;
    endcase

endmodule
