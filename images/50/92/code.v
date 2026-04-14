module top_module(input pulse,input clk,input rst,output reg out);initial out = 0; 
 parameter waiting_l = 2'b00, on = 2'b01, waiting_h = 2'b10; 
 reg[1:0] next_state, current_state; 
 always @ (posedge clk or posedge rst) begin 
  if(rst) begin 
  current_state <= waiting_l; 
  end 
  else begin 
  current_state <= next_state; 
  end 
 end 
 always @ (current_state or pulse) begin 
  if(current_state == on) begin 
  next_state <= waiting_h; 
  end 
  else if(current_state == waiting_h) begin 
  if(pulse) begin 
  next_state <= waiting_h; 
  end 
  else begin 
  next_state <= waiting_l; 
  end 
  end 
  else if(pulse) begin 
  next_state<= on; 
  end 
  else begin 
  next_state<= waiting_l; 
  end 
 end 
 always @(current_state or rst) begin 
  if(rst) 
  out <= 1'b0; 
  else if(current_state == on) 
  out <= 1'b1; 
  else 
  out <= 1'b0; 
 end 
 endmodule