module top_module(
  input [7:0] input_vector,
  output reg [7:0] output_vector
);integer i;
  
  always @ (input_vector) begin
    for (i = 0; i < 8; i = i + 2) begin
      output_vector[i] = input_vector[i+1];
      output_vector[i+1] = input_vector[i];
    end
  end
  
endmodule