module top_module(clock, reset, enable_in, enable_out);input clock; 
  input reset; 
  input enable_in; 
  output enable_out; 
  reg [1:0] key_state, next_key_state; 
  reg enable_out; 
  parameter [1:0] KEY_FREE = 2'b00, KEY_PRESSED = 2'b01, KEY_RELEASED = 2'b10; 
  always @(posedge clock or negedge reset) begin 
  if (reset == 1'b0) 
  key_state <= KEY_FREE; 
  else 
  key_state <= next_key_state; 
  end 
  always @(key_state, enable_in) begin 
  next_key_state = key_state; 
  enable_out = 1'b0; 
  case (key_state) 
  KEY_FREE: begin 
  if (enable_in == 1'b0) 
  next_key_state = KEY_PRESSED; 
  end 
  KEY_PRESSED: begin 
  if (enable_in == 1'b1) 
  next_key_state = KEY_RELEASED; 
  end 
  KEY_RELEASED: begin 
  enable_out = 1'b1; 
  next_key_state = KEY_FREE; 
  end 
  default: begin 
  next_key_state = 2'bxx; 
  enable_out = 1'bx; 
  end 
  endcase 
  end 
 endmodule