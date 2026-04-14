module top_module(input clk, input ce, input reset,
                input is_rendering,
                output reg [8:0] scanline,
                output reg [8:0] cycle,
                output reg is_in_vblank,
                output reg end_of_line,
                output reg at_last_cycle_group,
                output reg exiting_vblank,
                output reg entering_vblank,
                output reg is_pre_render);reg [8:0] cycle_counter;
  reg [8:0] scanline_counter;
  reg [1:0] cycle_group_counter;
  reg [1:0] pre_render_counter;
  reg [1:0] vblank_counter;
  reg [1:0] vblank_end_counter;
  
  assign at_last_cycle_group = (cycle[8:3] == 42);
  assign end_of_line = (cycle_counter == 340 && pre_render_counter == 1 && is_rendering) || (cycle_counter == 341 && pre_render_counter != 1);
  assign entering_vblank = (end_of_line && scanline_counter == 239);
  assign exiting_vblank = (end_of_line && scanline_counter == 259);
  assign is_in_vblank = (vblank_counter == 1);
  assign is_pre_render = (scanline_counter == -1);
  
  always @(posedge clk) begin
    if (reset) begin
      cycle_counter <= 0;
      scanline_counter <= 0;
      cycle_group_counter <= 0;
      pre_render_counter <= 0;
      vblank_counter <= 0;
      vblank_end_counter <= 0;
    end else if (ce) begin
      cycle_counter <= (end_of_line) ? 0 : cycle_counter + 1;
      scanline_counter <= (end_of_line && scanline_counter == 260) ? 0 : scanline_counter + 1;
      cycle_group_counter <= (end_of_line && at_last_cycle_group) ? cycle_group_counter + 1 : cycle_group_counter;
      pre_render_counter <= (scanline_counter == -1) ? pre_render_counter + 1 : 0;
      vblank_counter <= (entering_vblank) ? 1 : (exiting_vblank) ? 0 : vblank_counter;
      vblank_end_counter <= (exiting_vblank) ? vblank_end_counter + 1 : 0;
    end
  end
  
  assign cycle = cycle_counter;
  assign scanline = (scanline_counter == 260) ? 240 : scanline_counter;
  
endmodule