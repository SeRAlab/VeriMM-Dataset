module top_module(
  input [15:0] baud_divisor,
  input clk,
  input clk_en,
  input reset_n,
  input rx_char_ready,
  input rxd,
  output source_rxd
);reg [7:0] received_data;

  always @(posedge clk) begin
    if (reset_n == 0) begin
      received_data <= 8'b0;
    end else if (rx_char_ready == 1) begin
      received_data <= rxd;
    end
  end

  assign source_rxd = received_data;

endmodule