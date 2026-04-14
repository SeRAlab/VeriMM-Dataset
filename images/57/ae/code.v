module top_module(
  input din,
  input clk,
  input reset,
  input clear,
  output reg q
);// D flip-flop with asynchronous active-low reset
  always @(posedge clk or negedge reset) begin
    if (!reset) begin
      q <= 1'b0;
    end else begin
      q <= din;
    end
  end

  // Clear logic
  always @(*) begin
    if (clear) begin
      q <= 1'b1;
    end
  end

endmodule