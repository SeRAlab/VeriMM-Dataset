module top_module(
  input clk,
  input reset_n,
  input [7:0] data_in,
  input enable,
  output reg [7:0] led_out
);always @(posedge clk) begin
    if (~reset_n) begin
      led_out <= 8'h00;
    end else if (enable) begin
      led_out <= data_in;
    end else begin
      led_out <= 8'h00;
    end
  end

endmodule