module top_module(input clock,input reset,input s_tick,input tx_start,input [7:0] data_in,output reg tx,output reg tx_done);localparam [1:0] IDLE = 0, 
  START = 1, 
  SEND = 2, 
  STOP = 3; 
  localparam B_start=1'b0, 
  B_stop= 1'b1; 
  reg [1:0] current_state, next_state; 
  reg [2:0] B_sent; 
  reg [7:0] d_in; 
  always @(posedge clock, posedge reset) 
  begin 
  if(reset) begin 
  current_state <= IDLE; 
  end 
  else 
  current_state <= next_state; 
  end 
  always @(posedge clock) begin 
  case(current_state) 
  IDLE: begin 
  tx_done = 0; 
  tx= 1; 
  if(~tx_start) begin 
  next_state = START; 
  end 
  else next_state = IDLE; 
  end 
  START: begin 
  d_in = data_in; 
  B_sent = 0; 
  if(s_tick) begin 
  tx = B_start; 
  next_state = SEND; 
  end 
  end 
  SEND: begin 
  if(s_tick) begin 
  tx = d_in[B_sent]; 
  if(B_sent == 7) begin 
  next_state = STOP; 
  end 
  else begin 
  B_sent = B_sent + 3'b1; 
  end 
  end 
  end 
  STOP: begin 
  if(s_tick) begin 
  tx = B_stop; 
  tx_done = 1; 
  next_state=IDLE; 
  end 
  else if (tx_done==1) begin 
  tx_done=0; 
  end 
  end 
  endcase 
  end 
 endmodule