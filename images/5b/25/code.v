module top_module(
  input [31:0] in_word,
  input [15:0] threshold,
  output reg [15:0] out_word,
  output reg threshold_exceeded
);reg [15:0] upper_half;
  reg [15:0] lower_half;
  reg [15:0] sum;

  // Split input word into upper and lower halves
  assign upper_half = in_word[31:16];
  assign lower_half = in_word[15:0];

  // Calculate sum of upper and lower halves
  always @* begin
    sum = upper_half + lower_half;
  end

  // Compare sum to threshold value
  always @* begin
    if (sum > threshold) begin
      threshold_exceeded = 1;
    end else begin
      threshold_exceeded = 0;
    end
  end

  // Assign output word to sum
  assign out_word = sum;

endmodule