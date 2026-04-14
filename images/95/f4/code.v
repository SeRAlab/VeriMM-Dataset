module bin2bcd
(
  input [3:0] bin,
  output reg [4:0] bcd
);

  always @(*) begin
    case (bin)
      4'b0000: bcd = 5'b00000;
      4'b0001: bcd = 5'b00001;
      4'b0010: bcd = 5'b00010;
      4'b0011: bcd = 5'b00011;
      4'b0100: bcd = 5'b00100;
      4'b0101: bcd = 5'b00101;
      4'b0110: bcd = 5'b00110;
      4'b0111: bcd = 5'b00111;
      4'b1000: bcd = 5'b01000;
      4'b1001: bcd = 5'b01001;
      4'b1010: bcd = 5'b10000; // 10 in BCD
      4'b1011: bcd = 5'b10001; // 11 in BCD
      4'b1100: bcd = 5'b10010; // 12 in BCD
      4'b1101: bcd = 5'b10011; // 13 in BCD
      4'b1110: bcd = 5'b10100; // 14 in BCD
      4'b1111: bcd = 5'b10101; // 15 in BCD
      default: bcd = 5'b00000; // Default case
    endcase
  end

endmodule