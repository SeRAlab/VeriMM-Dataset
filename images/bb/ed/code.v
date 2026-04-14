module top_module(input start,input clk,input cnt_done,input lsb,output start_process,output reg add,output reg shift,output reg count_up,output reg done);reg [2:0] state, nextState; 
  parameter off = 0, on = 1, process = 2, finish = 3; 
  assign start_process = start; 
  initial begin 
  state = off; 
  end 
  always @(posedge clk) begin 
  state <= nextState; 
  end 
  always @(start or lsb or cnt_done or state) begin 
  add = 0; 
  case (state) 
  off: begin 
  if (start) nextState = on; 
  else nextState = off; 
  end 
  on: begin 
  if (lsb) begin 
  nextState = process; 
  add = 1; 
  end 
  else begin 
  nextState = process; 
  end 
  end 
  process: begin 
  if (cnt_done) nextState = finish; 
  else nextState = on; 
  end 
  finish: begin 
  nextState = off; 
  end 
  default: begin 
  nextState = off; 
  end 
  endcase 
  end 
  always @(state) begin 
  shift = 0; 
  count_up = 0; 
  done = 0; 
  case (state) 
  process: begin 
  shift = 1; 
  count_up = 1; 
  end 
  finish: begin 
  done = 1; 
  end 
  default: begin 
  shift = 0; 
  count_up = 0; 
  done = 0; 
  end 
  endcase 
  end 
 endmodule