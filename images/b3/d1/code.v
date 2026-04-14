module top_module(
  input clk,
  input rst,
  input [9:0] h_count,
  input [9:0] v_count,
  output reg h_sync,
  output reg v_sync
);// Constants for VGA timing
  parameter H_SYNC_PULSE_WIDTH = 96;
  parameter H_FRONT_PORCH = 16;
  parameter H_BACK_PORCH = 48;
  parameter V_SYNC_PULSE_WIDTH = 2;
  parameter V_FRONT_PORCH = 10;
  parameter V_BACK_PORCH = 33;
  parameter H_TOTAL = 800;
  parameter V_TOTAL = 525;

  // Counters for tracking pixel position
  reg [9:0] h_counter = 0;
  reg [9:0] v_counter = 0;

  // Horizontal sync signal generation
  always @(posedge clk) begin
    if (rst) begin
      h_counter <= 0;
      h_sync <= 1;
    end else begin
      if (h_counter >= H_TOTAL - 1) begin
        h_counter <= 0;
        h_sync <= 0;
      end else if (h_counter >= H_TOTAL - H_SYNC_PULSE_WIDTH - H_BACK_PORCH) begin
        h_sync <= 1;
      end else begin
        h_sync <= 0;
      end
      h_counter <= h_counter + 1;
    end
  end

  // Vertical sync signal generation
  always @(posedge clk) begin
    if (rst) begin
      v_counter <= 0;
      v_sync <= 1;
    end else begin
      if (v_counter >= V_TOTAL - 1) begin
        v_counter <= 0;
        v_sync <= 0;
      end else if (v_counter >= V_TOTAL - V_SYNC_PULSE_WIDTH - V_BACK_PORCH) begin
        v_sync <= 1;
      end else begin
        v_sync <= 0;
      end
      v_counter <= v_counter + 1;
    end
  end

endmodule