module top_module(
  input [7:0] a,
  input [7:0] b,
  input clk,              // Added the clk input
  output reg [7:0] sum,
  output reg [7:0] diff,
  output reg [7:0] prod,
  output reg [7:0] quot,
  output reg valid
);always @(*) begin
    sum = a + b;
    diff = a - b;
    prod = a * b;
    if (b != 0)           // Preventing division by zero
      quot = a / b;
    else
      quot = 8'hFF;       // Assign an error value or appropriate signal
    valid = 0;
  end
  
  always @(posedge clk) begin
    valid <= 1;
  end

endmodule