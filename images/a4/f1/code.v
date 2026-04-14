module top_module(
  input reset,
  input clk,
  input async_reset,
  output sync_reset
);reg [1:0] reset_sync;
  always @(posedge clk) begin
    reset_sync <= {reset_sync[0], async_reset};
  end
  
  assign sync_reset = reset_sync[1];

endmodule