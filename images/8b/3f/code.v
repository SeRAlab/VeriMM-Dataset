module top_module(input clock, reset, start, Nothing, Zero, Q0,output reg Ready, Load_regs, Decr_P, Add_regs, Shift_regs);parameter S_idle = 2'b00; 
 parameter S_add = 2'b01; 
 parameter S_shift = 2'b10; 
 reg [1:0] state, next_state; 
 always @(posedge clock, posedge reset) 
  if (reset) 
  state <= S_idle; 
  else 
  state <= next_state; 
 always @(*) 
 begin 
  Load_regs = 0; 
  Decr_P = 0; 
  Add_regs = 0; 
  Shift_regs = 0; 
  Ready = 0; 
  case (state) 
  S_idle: begin 
  if (start) begin 
  next_state = S_add; 
  Load_regs = 1; 
  end else 
  next_state = S_idle; 
  Ready = 1; 
  end 
  S_add: begin 
  next_state = S_shift; 
  Decr_P = 1; 
  if (Q0) Add_regs = 1; 
  end 
  S_shift: begin 
  next_state = (Zero | Nothing) ? S_idle : S_add; 
  Shift_regs = 1; 
  end 
  default: next_state = S_idle; 
  endcase 
 end 
 endmodule