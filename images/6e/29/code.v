module top_module(
  input [3:0] input_vector,
  output [3:0] output_vector,
  output reg [1:0] num_ones,
  output reg [1:0] num_zeros
);assign output_vector[0] = input_vector[0];
  assign output_vector[1] = input_vector[1];
  assign output_vector[2] = input_vector[2];
  assign output_vector[3] = input_vector[3];
  
  always @(*) begin
    num_ones = {input_vector[3], input_vector[2]} + {input_vector[1], input_vector[0]};
    num_zeros = {~input_vector[3], ~input_vector[2]} + {~input_vector[1], ~input_vector[0]};
  end
  
endmodule