module adder_overflow_detection (
  input [3:0] a,
  input [3:0] b,
  output reg [3:0] sum,
  output reg overflow
);
  
  always @(a, b) begin
    sum = a + b;
    if (sum > 15) begin
      overflow = 1;
    end else begin
      overflow = 0;
    end
  end
  
endmodule
