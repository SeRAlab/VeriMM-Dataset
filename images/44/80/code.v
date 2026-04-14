module top_module(
  input wire slowest_sync_clk,
  input wire dcm_locked,
  input wire ext_reset_in,
  input wire mb_debug_sys_rst,
  input wire aux_reset_in,
  output reg [4:0] lpf_int // Changed to reg to resolve compilation error
);// Synchronize input signals to slowest_sync_clk domain
  reg sync_ext_reset_in, sync_mb_debug_sys_rst, sync_aux_reset_in, sync_dcm_locked;
  always @(posedge slowest_sync_clk) begin
    sync_ext_reset_in <= ext_reset_in;
    sync_mb_debug_sys_rst <= mb_debug_sys_rst;
    sync_aux_reset_in <= aux_reset_in;
    sync_dcm_locked <= dcm_locked;
  end
  
  // Combine reset signals
  reg sync_reset;
  always @(posedge slowest_sync_clk) begin
    if (sync_ext_reset_in || sync_mb_debug_sys_rst || sync_aux_reset_in) begin
      sync_reset <= 1'b1;
    end else begin
      sync_reset <= 1'b0;
    end
  end
  
  // Implement low-pass filter
  reg [15:0] shift_reg;
  reg [15:0] sum;
  always @(posedge slowest_sync_clk) begin
    if (sync_reset) begin
      shift_reg <= 16'h0000;
      sum <= 16'h0000;
    end else begin
      shift_reg <= {shift_reg[14:0], sync_dcm_locked};
      sum <= sum + sync_dcm_locked - shift_reg[0];
    end
  end
  
  // Assign filtered output value
  always @(posedge slowest_sync_clk) begin
    lpf_int <= sum[4:0]; // Moved assignment to a clocked process
  end

endmodule