module top_module(
  input clk_in,
  input signed [31:0] shift_amount,
  output clk_out
);reg [31:0] counter;
  reg delayed_clk;
  reg advanced_clk;

  always @(posedge clk_in) begin
    counter <= (counter == $unsigned({31'b0, shift_amount})) ? 0 : counter + 1;
    delayed_clk <= (counter >= $unsigned({31'b0, shift_amount})) ? 1'b1 : 1'b0;
    advanced_clk <= (counter < $unsigned({31'b0, -shift_amount})) ? 1'b1 : 1'b0;
  end

  assign clk_out = (shift_amount > 0) ? delayed_clk : advanced_clk;

endmodule