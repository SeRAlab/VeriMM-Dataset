module top_module(aux_reset_in,
     bus_struct_reset,
     dcm_locked,
     ext_reset_in,
     interconnect_aresetn,
     mb_debug_sys_rst,
     mb_reset,
     peripheral_aresetn,
     peripheral_reset,
     slowest_sync_clk);input slowest_sync_clk;
  input ext_reset_in;
  input aux_reset_in;
  input mb_debug_sys_rst;
  input dcm_locked;
  output mb_reset;
  output [0:0]bus_struct_reset;
  output [0:0]peripheral_reset;
  output [0:0]interconnect_aresetn;
  output [0:0]peripheral_aresetn;

  reg mb_reset;
  reg [0:0]bus_struct_reset;
  reg [0:0]peripheral_reset;
  reg [0:0]interconnect_aresetn;
  reg [0:0]peripheral_aresetn;

  // Implement the processor system reset signal
  always @(posedge slowest_sync_clk) begin
    if (ext_reset_in == 1'b1 || aux_reset_in == 1'b0 || mb_debug_sys_rst == 1'b1 || dcm_locked == 1'b0) begin
      mb_reset <= 1'b0;
    end else begin
      mb_reset <= 1'b1;
    end
  end

  // Implement the bus structure reset signal
  always @(posedge slowest_sync_clk) begin
    if (mb_reset == 1'b1) begin
      bus_struct_reset <= 1'b1;
    end else begin
      bus_struct_reset <= 1'b0;
    end
  end

  // Implement the peripheral reset signal
  always @(posedge slowest_sync_clk) begin
    if (mb_reset == 1'b1) begin
      peripheral_reset <= 1'b1;
    end else begin
      peripheral_reset <= 1'b0;
    end
  end

  // Implement the interconnect reset signal
  always @(posedge slowest_sync_clk) begin
    if (mb_reset == 1'b1) begin
      interconnect_aresetn <= 1'b0;
    end else begin
      interconnect_aresetn <= 1'b1;
    end
  end

  // Implement the peripheral reset signal
  always @(posedge slowest_sync_clk) begin
    if (mb_reset == 1'b1) begin
      peripheral_aresetn <= 1'b0;
    end else begin
      peripheral_aresetn <= 1'b1;
    end
  end

endmodule