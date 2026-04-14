module top_module( input[7:0] input1, output reg[4:0] o );integer i;
always @(input1)
begin
o = 0;
for ( i = 0; i < 8; i = i+1)
	if( input1[i] == 1'b1)
		o = o +1;
end
endmodule