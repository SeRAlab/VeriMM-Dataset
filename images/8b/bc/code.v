module top_module(
  input clk,
  input reset,
  input enable,
  input d,
  output reg q
);reg [2:0] shift_reg;

  always @(posedge clk) begin
    if (reset) begin
      shift_reg <= 3'b0;
      q <= 1'b0;
    end else if (enable) begin
      shift_reg <= {shift_reg[1:0], d};
      q <= shift_reg[2];
    end
  end

endmodule