module top_module(
  input clk,
  input reset,
  input mode,
  input [3:0] initial_value,
  output reg [3:0] counter_value
);always @(posedge clk) begin
    if (reset) begin
      counter_value <= initial_value;
    end else if (mode == 0) begin
      if (counter_value == 4'b1111) begin
        counter_value <= 4'b0000;
      end else begin
        counter_value <= counter_value + 1;
      end
    end else begin
      if (counter_value == 4'b0000) begin
        counter_value <= 4'b1111;
      end else begin
        counter_value <= counter_value - 1;
      end
    end
  end

endmodule