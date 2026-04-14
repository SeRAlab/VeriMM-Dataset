module top_module(
  input clk,
  input rst,
  input [31:0] led_data_in,
  input [31:0] led_mask_in,
  output reg [31:0] led_data_out,
  output reg led_data_changed,
  output reg led_data_masked
);always @(posedge clk) begin
    if (rst) begin
      led_data_out <= 32'h00000000;
      led_data_changed <= 1'b0;
      led_data_masked <= 1'b0;
    end else begin
      if (led_mask_in != 32'h00000000) begin
        led_data_out <= (led_data_out & ~led_mask_in) | (led_data_in & led_mask_in);
        led_data_masked <= 1'b1;
      end else if (led_data_in != led_data_out) begin
        led_data_out <= led_data_in;
        led_data_changed <= 1'b1;
      end
    end
  end

endmodule