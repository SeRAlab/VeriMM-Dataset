module top_module(clock, enable, clear, disp, dir, countValue, outputValue);input clock, enable, clear, disp, dir; 
  input [3:0] countValue; 
  output [15:0] outputValue; 
  reg [15:0] counter_state, next_counter_state; 
  always @(posedge clock or negedge clear) begin 
  if (clear == 0) 
  counter_state <= 16'b0; 
  else 
  counter_state <= next_counter_state; 
  end 
  always @(enable or counter_state) begin 
  next_counter_state = counter_state; 
  if (!enable) 
  next_counter_state = counter_state; 
  else begin 
  if (dir) 
  next_counter_state = counter_state + countValue; 
  else 
  next_counter_state = counter_state - countValue; 
  if (!disp) 
  next_counter_state = 16'h0580; 
  end 
  end 
  assign outputValue = counter_state; 
 endmodule