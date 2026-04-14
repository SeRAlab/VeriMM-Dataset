module top_module(input clk, start, reset,input [3:0] din,output reg [6:0] dout,output reg done_tick);reg [1:0] next_s, current_s; 
 reg [3:0] next_n, n; 
 reg [6:0] next_fn, fn; 
 localparam idle=2'b00, op=2'b01, done=2'b10; 
 always @(posedge clk, posedge reset) 
 if (reset) 
  begin 
  current_s <= idle; 
  n <= 0; 
  fn <= 1; 
  end 
 else 
  begin 
  current_s <= next_s; 
  n <= next_n; 
  fn <= next_fn; 
  end 
 always @* begin 
  next_s = current_s; 
  next_n = n; 
  next_fn = fn; 
  done_tick = 0; 
  dout = 0; 
  case(current_s) 
  idle: 
  begin 
  next_n=0; 
  next_fn=1; 
  next_s = (start) ? ((din==0) ? done:op) : idle; 
  end 
  op: 
  begin 
  next_n = n + 1; 
  next_fn = fn + 5; 
  next_s = (n==din) ? done : op; 
  end 
  done: 
  begin 
  done_tick = 1'b1; 
  dout = fn; 
  next_s = idle; 
  end 
  default: next_s = idle; 
  endcase 
 end 
 endmodule