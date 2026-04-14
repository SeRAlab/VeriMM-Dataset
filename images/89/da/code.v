module decoder4to16 (
  input [3:0] bin,
  output reg [15:0] onehot
);

  always @(*) begin
    case (bin)
      4'b0000: onehot = 16'b0000000000000001;
      4'b0001: onehot = 16'b0000000000000010;
      4'b0010: onehot = 16'b0000000000000100;
      4'b0011: onehot = 16'b0000000000001000;
      4'b0100: onehot = 16'b0000000000010000;
      4'b0101: onehot = 16'b0000000000100000;
      4'b0110: onehot = 16'b0000000001000000;
      4'b0111: onehot = 16'b0000000010000000;
      4'b1000: onehot = 16'b0000000100000000;
      4'b1001: onehot = 16'b0000001000000000;
      4'b1010: onehot = 16'b0000010000000000;
      4'b1011: onehot = 16'b0000100000000000;
      4'b1100: onehot = 16'b0001000000000000;
      4'b1101: onehot = 16'b0010000000000000;
      4'b1110: onehot = 16'b0100000000000000;
      4'b1111: onehot = 16'b1000000000000000;
      default: onehot = 16'b0000000000000000;
    endcase
  end

endmodule