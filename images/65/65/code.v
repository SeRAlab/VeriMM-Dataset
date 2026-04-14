module top_module(input1, input2, out);input [3:0] input1, input2;
	output [7:0] out;
	
	reg [7:0] out;

	always@(*)
	begin
		out = input1 + input2;
		if(out > 9)
			out = out + 6;
	end
endmodule