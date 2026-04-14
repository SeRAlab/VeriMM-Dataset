module top_module(
  input slowest_clk,
  input ext_reset,
  input aux_reset,
  input dcm_locked,
  input debug_sys_rst,
  output reg sys_reset,
  output reg [0:0]bus_struct_reset,
  output reg [0:0]peripheral_reset,
  output reg [0:0]interconnect_reset,
  output reg [0:0]peripheral_aresetn
);reg [1:0] reset_state;
  reg [1:0] sync_reset_state;

  always @(posedge slowest_clk) begin
    // Synchronize reset signals to slowest clock
    sync_reset_state <= reset_state;
    if (dcm_locked) begin
      reset_state[0] <= ~ext_reset;
      reset_state[1] <= reset_state[0] & (~aux_reset | sync_reset_state[1]);
    end
  end

  // System reset
  always @(posedge slowest_clk) begin
    if (debug_sys_rst) begin
      sys_reset <= 1'b1;
    end else if (sync_reset_state[1]) begin
      sys_reset <= 1'b1;
    end else begin
      sys_reset <= 1'b0;
    end
  end

  // Bus structure reset
  always @(posedge slowest_clk) begin
    if (sync_reset_state[1]) begin
      bus_struct_reset <= 1'b1;
    end else begin
      bus_struct_reset <= 1'b0;
    end
  end

  // Peripheral reset
  always @(posedge slowest_clk) begin
    if (sync_reset_state[1]) begin
      peripheral_reset <= 1'b1;
    end else begin
      peripheral_reset <= 1'b0;
    end
  end

  // Interconnect reset
  always @(posedge slowest_clk) begin
    if (sync_reset_state[1]) begin
      interconnect_reset <= 1'b1;
    end else begin
      interconnect_reset <= 1'b0;
    end
  end

  // Peripheral active reset
  always @(posedge slowest_clk) begin
    if (sync_reset_state[1]) begin
      peripheral_aresetn <= 1'b0;
    end else begin
      peripheral_aresetn <= 1'b1;
    end
  end

endmodule