module top_module(
  input [9:0] in_vector,
  output reg [9:0] max_value
);integer i;
  
  always @(*) begin
    max_value = in_vector[0];
    for (i = 1; i < 10; i = i + 1) begin
      if (in_vector[i] > max_value) begin
        max_value = in_vector[i];
      end
    end
  end

endmodule