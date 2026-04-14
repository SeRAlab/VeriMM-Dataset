module top_module(
	out1,
	out0,
	in_count0,
	in_count1,
	clk,
	rst_n
    );input out0,out1,clk,rst_n;

output reg in_count0,in_count1;

reg state0,next_state0,state1,next_state1;

always@*
if(state0==0)
in_count0=0;
else
in_count0=1'b1;

always@*
if(state1==0)
in_count1=0;
else
in_count1=1'b1;



always@*  begin
  case(state0)
  1'b0: 
			if(out0==1'b1) 
			next_state0=1'b1;
			else
			next_state0=0;
  
	1'b1: 
			if(out0==1'b1) 
			next_state0=1'b0;
			else
			next_state0=1'b1;
			
	default:  next_state0=1'b0;
	endcase
	
	case(state1)
  1'b0: 
			if(out1==1'b1) 
			next_state1=1'b1;
			else
			next_state1=0;
  
	1'b1: 
			if(out1==1'b1) 
			next_state1=1'b0;
			else
			next_state1=1'b1;
	default:  next_state1=1'b0;
	endcase
end
always @(posedge clk or negedge rst_n)
  if (~rst_n) begin
    state0 <= 0;
	 state1 <= 0;
	 end
  else begin
    state0 <= next_state0;
	 state1 <= next_state1;
	 end
endmodule