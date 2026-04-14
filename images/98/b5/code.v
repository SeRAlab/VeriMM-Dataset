module top_module(
		input Clk,		
		input X,			
		output Y			
);parameter IDLE = 0,
  			S1 	= 1,
  			S11 	= 2,
  			S110 	= 3,
  			S1100 = 4;
  
  reg [2:0] cur_state;
  
  
  assign Y = cur_state == S1100 ? 1 : 0;
  
 always @(posedge Clk) 
begin
 
 case(cur_state)
 IDLE: if(X)
 begin
 cur_state = S1;
 end
 else
 cur_state = IDLE;
 
 S1: if(X)
 cur_state = S11;
 else
 begin
 cur_state = IDLE;
 end
 
 S11: if(X)
 cur_state = S11;
 else
 begin
 cur_state = S110;
 end
 
 S110: if(X)
 cur_state = S1;
 else
 begin
 cur_state = S1100;
 end
 
 S1100: if(X)
 cur_state = S1;
 else
 begin
 cur_state = IDLE;
 end
 
 
 default:
 cur_state = IDLE;
 
 endcase
 end 
  












	

endmodule