module top_module(
  input rst,
  input clk,
  output rst_sync
);reg rst_sync_ff1, rst_sync_ff2;

  always @(posedge clk) begin
    rst_sync_ff1 <= rst;
    rst_sync_ff2 <= rst_sync_ff1;
  end

  assign rst_sync = ~rst_sync_ff2;

endmodule