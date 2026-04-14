module encoder4to2 (
  input [3:0] bin,
  output reg [1:0] enc
);

  always @(*) begin
    case (bin)
      4'b0001: enc = 2'b00;
      4'b0010: enc = 2'b01;
      4'b0100: enc = 2'b10;
      4'b1000: enc = 2'b11;
      default: enc = 2'b00;
    endcase
  end

endmodule