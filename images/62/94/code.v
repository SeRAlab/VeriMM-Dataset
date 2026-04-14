module top_module(
  input [1:0] input_bits,
  output reg [3:0] output_bits
);always @* begin
    case(input_bits)
      2'b00: output_bits = 4'b0001;
      2'b01: output_bits = 4'b0010;
      2'b10: output_bits = 4'b0100;
      2'b11: output_bits = 4'b1000;
      default: output_bits = 4'b0000;
    endcase
  end

endmodule