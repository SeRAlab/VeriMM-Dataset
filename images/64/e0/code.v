module top_module(clock, 
		eleventh, 
		twelfth, 
		out5);input	clock;
input eleventh;
input twelfth;
output  out5;
reg     out5;
reg temp6;

always @(posedge clock)
begin
	temp6 <= eleventh ^ twelfth;
	out5 <= temp6 | twelfth;
end

endmodule