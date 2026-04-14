module encoder8to3 (
  input [7:0] bin,
  output reg [2:0] enc
);

  always @(*) begin
    case (bin)
      8'b00000001: enc = 3'b000;
      8'b00000010: enc = 3'b001;
      8'b00000100: enc = 3'b010;
      8'b00001000: enc = 3'b011;
      8'b00010000: enc = 3'b100;
      8'b00100000: enc = 3'b101;
      8'b01000000: enc = 3'b110;
      8'b10000000: enc = 3'b111;
      default: enc = 3'b000;
    endcase
  end

endmodule