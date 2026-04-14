module top_module(
  input [7:0] vector1,
  input [7:0] vector2,
  output reg [7:0] swapped_vector1,  // Changed to reg
  output reg [7:0] swapped_vector2   // Changed to reg
);reg [7:0] temp;

  always @(*) begin
    temp = vector1;
    swapped_vector1 = vector2;
    swapped_vector2 = temp;
  end

endmodule