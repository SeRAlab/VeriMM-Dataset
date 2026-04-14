module top_module(
  input reset_n,
  input clk,
  output reset
);reg reset_synced;
  reg [1:0] reset_synced_d;

  always @(posedge clk) begin
    reset_synced_d <= {reset_synced, reset_n};
    reset_synced <= reset_synced_d[1] & ~reset_synced_d[0];
  end

  assign reset = reset_synced;

endmodule