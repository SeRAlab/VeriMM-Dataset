module top_module(
  input clk_in1,
  input [15:0] freq_div,
  output reg clk_out1
);reg [15:0] counter = 0;
  reg [15:0] div = freq_div - 1;

  always @(posedge clk_in1) begin
    counter <= counter + 1;
    if (counter >= div) begin
      counter <= 0;
      clk_out1 <= ~clk_out1;
    end
  end

endmodule