module top_module(input wire clk, reset,input wire rx_done_tick,input wire [7:0] dout,output reg gotten_code_flag);localparam break_code = 8'hF0; 
 localparam wait_break_code = 1'b0; 
 localparam get_code = 1'b1; 
 reg state_next, state_reg; 
 always @(posedge clk, posedge reset) 
  if (reset) 
  state_reg <= wait_break_code; 
  else 
  state_reg <= state_next; 
 always @* 
 begin 
  gotten_code_flag = 1'b0; 
  state_next = state_reg; 
  case (state_reg) 
  wait_break_code: 
  if (rx_done_tick == 1'b1 && dout == break_code) 
  state_next = get_code; 
  get_code: 
  if (rx_done_tick) 
  begin 
  gotten_code_flag =1'b1; 
  state_next = wait_break_code; 
  end 
  endcase 
 end 
 endmodule