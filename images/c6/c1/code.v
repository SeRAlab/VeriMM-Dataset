module addition_4bit (
  input [3:0] a,
  input [3:0] b,
  output reg [3:0] sum
);

  always @(*) begin
    sum = a + b;
    if(sum > 15) begin
      sum = sum - 16;
    end
  end

endmodule
