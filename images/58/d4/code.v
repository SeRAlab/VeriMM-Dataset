module decoder3to8 (
  input [2:0] bin,
  output reg [7:0] onehot
);

  always @(*) begin
    case (bin)
      3'b000: onehot = 8'b00000001;
      3'b001: onehot = 8'b00000010;
      3'b010: onehot = 8'b00000100;
      3'b011: onehot = 8'b00001000;
      3'b100: onehot = 8'b00010000;
      3'b101: onehot = 8'b00100000;
      3'b110: onehot = 8'b01000000;
      3'b111: onehot = 8'b10000000;
      default: onehot = 8'b00000000;
    endcase
  end

endmodule