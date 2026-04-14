module top_module(
  input [31:0] in,
  output reg [15:0] out
);reg [31:0] guess;
  reg [31:0] estimate;
  reg [31:0] square;

  initial begin
    guess = {16'b0, 16'b1}; // Initialize guess to half of the maximum possible value
    estimate = {16'b0, 16'b0}; // Initialize estimate to 0
  end

  always @(*) begin
    square = guess * guess;
    if (square >= in) begin
      guess = guess >> 1;
    end else begin
      estimate = guess + estimate;
      guess = guess >> 1;
    end
  end

  always @(*) begin
    out = estimate[31:16];
  end

endmodule