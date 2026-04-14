module top_module(in, out);input [31:0] in;

output [63:0] out;

reg [63:0] out;

always@(in)begin
	if(in[31:26] == 'b000101 ||in[31:26] == 'b100101 )
		begin out = {{38{in[25]}},in[25:0]}; end
	else if(in[31:24] == 'b10110101 || in[31:24] == 'b10110100) 
		begin out = {{45{in[23]}}, in[23:5]}; end
	else if(in[31:21] == 'b11111000010 || in[31:21] == 'b11111000000) 
		begin out = {{55{in[20]}},in[20:12]}; end
	else if(in[31:21] == 'b11010011011 || in[31:21] == 'b11010011010)
		begin out = {{58{in[15]}},in[15:10]}; end
	else out = 64'b0;
end
endmodule