module top_module(
  input reset,
  input clk,
  output rst_sync
);parameter n = 2; // number of cycles that reset must be stable

reg [1:0] sync_reset; // two-stage synchronizer

always @(posedge clk) begin
  sync_reset[0] <= reset;
  sync_reset[1] <= sync_reset[0];
end

assign rst_sync = sync_reset[1];

endmodule