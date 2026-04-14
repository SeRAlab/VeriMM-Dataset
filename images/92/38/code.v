module top_module(
		input	[6:0]	address,
		input		clock,
		output  reg q 
		
);always@(posedge clock)
begin
	case(address)
7'd97 :   q=1;
7'd98 :   q=1;
default :   q=0;		
		
	endcase
end




endmodule