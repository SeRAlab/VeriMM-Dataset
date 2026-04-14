module top_module(input pclk,input href,input vsync,input [7:0] data,input M_AXIS_TREADY,output M_AXIS_TVALID,output M_AXIS_TLAST,output M_AXIS_TUSER,output [31:0] M_AXIS_TDATA);reg [1:0] state = 2'b0; 
 reg [9:0] pixel_counter = 10'b0; 
 reg [23:0] data_latch = 24'b0; 
 always @(posedge pclk) 
  begin 
  if(vsync) 
  begin 
  state <= 2'b0; 
  pixel_counter <= 32'b0; 
  end 
  else 
  begin 
  data_latch <= {data_latch[15:0], data}; 
  state <= {state[0], href & !state[0]}; 
  if(state[1]) 
  pixel_counter <= pixel_counter + 1; 
  end 
  end 
 assign M_AXIS_TVALID = state[1]; 
 assign M_AXIS_TLAST = ((pixel_counter % 640) == 639) ? 1'b1 : 1'b0; 
 assign M_AXIS_TUSER = (pixel_counter == 0) ? 1'b1 : 1'b0; 
 assign M_AXIS_TDATA = {8'b0, data_latch[4:0], {3{data_latch[0]}}, data_latch[10:5], {2{data_latch[5]}}, data_latch[15:11], {3{data_latch[11]}}}; 
 endmodule