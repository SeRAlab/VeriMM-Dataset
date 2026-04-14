module top_module(
  input [2:0] input_bits,
  output reg [1:0] output_bits
);always @(*) begin
    case (input_bits)
      3'b000: output_bits = 2'b00;  // Corrected from 2'b001
      3'b001: output_bits = 2'b01;  // Corrected from 2'b010
      3'b010: output_bits = 2'b10;  // Corrected from 2'b011
      3'b011: output_bits = 2'b11;  // Corrected from 2'b100
      3'b100: output_bits = 2'b00;  // Corrected from 2'b101
      3'b101: output_bits = 2'b01;  // Corrected from 2'b110
      3'b110: output_bits = 2'b10;  // Corrected from 2'b111
      3'b111: output_bits = 2'b11;  // Corrected from 2'b000
      default: output_bits = 2'b00;  // Default case for safety
    endcase
  end

endmodule