module async_reset_release (
  input rst,
  input clk,
  output reg out
);

  reg rst_sync;
  reg out_latch;

  always @(posedge clk) begin
    rst_sync <= rst;
    if (rst_sync) begin
      out <= 0;
      out_latch <= 0;
    end else begin
      out_latch <= 1;
    end
  end

  always @(posedge clk) begin
    if (!rst_sync) begin
      out <= out_latch;
    end
  end

endmodule