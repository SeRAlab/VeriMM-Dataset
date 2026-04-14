module top_module(next_WSTATE,WSTATE);input [1:0] WSTATE; 
  output [1:0] next_WSTATE; 
  reg [1:0] next_WSTATE; 
  parameter 
  WIDLE = 0, 
  WCB0 = 1; 
  always @ (WSTATE) begin 
  next_WSTATE = 2'b0; 
  case (1'b1) 
  WSTATE[WIDLE]: 
  next_WSTATE[1'b0] = 1'b1; 
  WSTATE[WCB0]: 
  next_WSTATE[WCB0] = 1'b1; 
  endcase 
  end 
 endmodule