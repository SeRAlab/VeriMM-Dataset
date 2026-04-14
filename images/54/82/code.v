module top_module(input clock,input wire start,output wire complete);reg start_1, start_2; 
 reg [5:0] state; 
 parameter [5:0] ST_RST = 6'h00, 
  ST_IDLE = 6'h01; 
 always @(posedge clock) begin 
  {start_2, start_1} <= {start_1, start}; 
  case(state) 
  ST_RST: begin 
  state <= ST_IDLE; 
  end 
  ST_IDLE: begin 
  if( start_2 ) begin 
  state <= 3; 
  end 
  end 
  3: begin 
  state <= 4; 
  end 
  4: begin 
  state <= 5; 
  end 
  5: begin 
  state <= 6; 
  end 
  6: begin 
  state <= ST_IDLE; 
  end 
  endcase 
 end 
 endmodule