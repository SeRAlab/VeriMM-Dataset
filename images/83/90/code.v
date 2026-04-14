module decoder2to4
(
  input  [1:0] in,
  output [3:0] out
);

assign out = (in == 2'b00) ? 4'b0001 :
             (in == 2'b01) ? 4'b0010 :
             (in == 2'b10) ? 4'b0100 :
             (in == 2'b11) ? 4'b1000 : 4'b0000;

endmodule