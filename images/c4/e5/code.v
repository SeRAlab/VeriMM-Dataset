module comparator_4bit (
  input [3:0] A,
  input [3:0] B,
  output reg [1:0] EQ_LT_GT
);

  always @* begin
    if (A == B) begin
      EQ_LT_GT = 2'b01; // A is equal to B
    end else if (A < B) begin
      EQ_LT_GT = 2'b10; // A is less than B
    end else begin
      EQ_LT_GT = 2'b00; // A is greater than B
    end
  end

endmodule
