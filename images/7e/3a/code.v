module top_module( input S,R,clk,
		output reg Q,Qb);wire wire_Q,wire_Qb;

assign wire_Qb=~wire_Q;

always @ (posedge clk)
begin
	if(S && !R)				
		begin Q<=1; Qb<=~Qb; end
	else if(!S && R)			
		begin Q<=0; Qb<=~Qb; end
	else if(!S && !R)			
		begin Q<=Q; Qb<=~Qb; end
	else
		begin Q<=0; Qb<=0; end	     	
end
endmodule