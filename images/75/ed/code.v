module top_module(clock, in, out);input wire clock;
input wire in;
output reg out;

reg in_n1, in_n2, in_n3;






always @ (posedge clock)
begin
	if (in & in_n1 & in_n2 & in_n3) out <= 1; 			
	else if (~in & ~in_n1 & ~in_n2 & ~in_n3) out <=0;	
	else out <= out;								    			
	in_n1 <= in;										 			
	in_n2 <= in_n1;
	in_n3 <= in_n2;	
end 

endmodule