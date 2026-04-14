module top_module(inp, out);input [2:0] inp; 
wire [2:0] inp; 
output [1:0] out; 
reg [1:0]out;
wire y; 

always@ (inp) 
		begin
		if( inp == 3'b000)
		begin
			out <= 2'b00;
			end
		if( inp == 3'b001 )
		begin
			out <= 2'b01;
			end
		if( inp == 3'b010 || inp == 3'b011)
		begin
			out <= 2'b10;
			end
		if( inp == 3'b100 || inp == 3'b101 || inp == 3'b110 || inp == 3'b111 )
		begin
			out <= 2'b11;
			end
		end


endmodule