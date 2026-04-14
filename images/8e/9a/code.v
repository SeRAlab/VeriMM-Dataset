module top_module(
  input [3:0] s,
  input i15, i14, i13, i12, i11, i10, i9, i8, i7, i6, i5, i4, i3, i2, i1, i0,
  output reg z
);always @(*) begin
  case (s)
    4'b0000: z = i0;
    4'b0001: z = i1;
    4'b0010: z = i2;
    4'b0011: z = i3;
    4'b0100: z = i4;
    4'b0101: z = i5;
    4'b0110: z = i6;
    4'b0111: z = i7;
    4'b1000: z = i8;
    4'b1001: z = i9;
    4'b1010: z = i10;
    4'b1011: z = i11;
    4'b1100: z = i12;
    4'b1101: z = i13;
    4'b1110: z = i14;
    4'b1111: z = i15;
  endcase
end

endmodule