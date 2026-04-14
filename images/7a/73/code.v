module top_module(
  input clk,
  input reset,
  input clock_enable,
  output reg [2:0] count_out
);always @(posedge clk) begin
    if (reset) begin
      count_out <= 3'b0;
    end
    else if (clock_enable) begin
      if (count_out == 3'b111) begin
        count_out <= 3'b0;
      end
      else begin
        count_out <= count_out + 1;
      end
    end
  end

endmodule