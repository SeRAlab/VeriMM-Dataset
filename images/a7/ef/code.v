module top_module(
  input [31:0] input_data,
  output reg [15:0] output_sum
);reg [15:0] lower_bits_twos_comp;
  reg [15:0] upper_bits_twos_comp;
  reg [15:0] sum;

  assign lower_bits_twos_comp = ~input_data[15:0] + 1;
  assign upper_bits_twos_comp = ~input_data[31:16] + 1;

  always @(*) begin
    sum = lower_bits_twos_comp + upper_bits_twos_comp;
    if (sum > 32767) begin
      output_sum = 32767;
    end else begin
      output_sum = sum;
    end
  end

endmodule