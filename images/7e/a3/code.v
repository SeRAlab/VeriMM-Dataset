module decoder_2to4(
  input [1:0] sel,
  output [3:0] out
);

  assign out = (sel == 2'b00) ? 4'b0001 :
               (sel == 2'b01) ? 4'b0010 :
               (sel == 2'b10) ? 4'b0100 :
                                4'b1000;

endmodule