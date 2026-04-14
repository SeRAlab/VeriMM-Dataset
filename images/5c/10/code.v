module top_module(d,clock,reset,q);input d,clock,reset;
output q;
reg q;
always @ (posedge clock or posedge reset)
begin
	q<=d;
	if(reset)
	q<=0;
end
endmodule