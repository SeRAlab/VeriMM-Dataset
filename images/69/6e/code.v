module top_module (
    input [2:0] a,
    output reg [15:0] q
);  always @(*)
    case (a)
      0: q = 16'h650e;
      1: q = 16'h5a1c;
      2: q = 16'hecbe;
      3: q = 16'hd8d6;
      4: q = 16'h92dc;
      5: q = 16'hfc92;
      6: q = 16'h206b;
      7: q = 16'hf6c5;
    endcase

endmodule
