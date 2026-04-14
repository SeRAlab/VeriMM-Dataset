module top_module(
  input [15:0] input_vector,
  output reg [15:0] output_vector
);integer i;
  reg [7:0] first_half;
  reg [7:0] second_half;

  always @(*) begin
    for (i = 0; i < 8; i = i + 1) begin
      first_half[i] = input_vector[7 - i];
      second_half[i] = input_vector[15 - i];
    end
    output_vector = {second_half, first_half};
  end

endmodule