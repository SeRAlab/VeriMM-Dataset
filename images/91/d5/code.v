module top_module(
  input [2:0] input_bits,
  output reg [1:0] output_bits
);always @(*) begin
    if (input_bits[0] == 1) // check if LSB is 1
      output_bits = 2'b01;
    else
      output_bits = 2'b10;
  end

endmodule