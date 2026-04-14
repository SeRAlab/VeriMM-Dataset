module top_module(
  input clk_in,
  output reg clk_out_1,
  output reg clk_out_2
);reg [1:0] counter = 2'b00;
  always @(posedge clk_in) begin
    counter <= counter + 1;
    if (counter == 2'b10) begin
      counter <= 2'b00;
      clk_out_1 <= ~clk_out_1;
      clk_out_2 <= ~clk_out_2;
    end
  end
endmodule