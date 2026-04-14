module top_module(
  input clock,
  input reset,
  input count_enable,
  output reg [3:0] Q
);always @(posedge clock) begin
    if (reset) begin
      Q <= 4'b0;
    end else if (count_enable) begin
      Q <= Q + 1;
    end
  end

endmodule