module top_module(
  input clk_in,
  input [31:0] freq_div,
  output reg clk_out,
  output reg locked
);reg [31:0] counter = 0;
  reg [31:0] threshold;

  // Calculate threshold based on freq_div only when it changes
  always @(posedge clk_in) begin
    threshold <= freq_div / 2;
  end

  // Simple clock divider logic
  always @(posedge clk_in) begin
    if (counter >= freq_div - 1) begin
      counter <= 0;
      clk_out <= ~clk_out;
    end else begin
      counter <= counter + 1;
    end
  end

  // Locked signal logic handling
  always @(posedge clk_in) begin
    if (counter >= threshold) begin
      locked <= 1'b1; // Indicating the clock is "locked"
    end else begin
      locked <= 1'b0;
    end
  end

endmodule