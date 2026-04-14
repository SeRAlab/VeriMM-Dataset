module top_module(input clk, input ce, input reset,
                input is_rendering,
                output reg [8:0] scanline,
                output reg [8:0] cycle,
                output reg is_in_vblank,
                output end_of_line,
                output at_last_cycle_group,
                output exiting_vblank,
                output entering_vblank,
                output reg is_pre_render);reg second_frame;
  
  
  
  
  
  assign at_last_cycle_group = (cycle[8:3] == 42);
  
  assign end_of_line = at_last_cycle_group && cycle[3:0] == (is_pre_render && second_frame && is_rendering ? 3 : 4);
  
  assign entering_vblank = end_of_line && scanline == 240;
  
  assign exiting_vblank = end_of_line && scanline == 260;
  
  wire new_is_in_vblank = entering_vblank ? 1'b1 : exiting_vblank ? 1'b0 : is_in_vblank;
  
  always @(posedge clk) if (reset) begin
    cycle <= 0;
    is_in_vblank <= 1;
  end else if (ce) begin
    cycle <= end_of_line ? 0 : cycle + 1;
    is_in_vblank <= new_is_in_vblank;
  end


    

  always @(posedge clk) if (reset) begin
    scanline <= 0;
    is_pre_render <= 0;
    second_frame <= 0;
  end else if (ce && end_of_line) begin
    
    scanline <= exiting_vblank ? 9'b111111111 : scanline + 1;
    
    is_pre_render <= exiting_vblank;
    
    if (exiting_vblank)
      second_frame <= !second_frame;
  end
  
endmodule