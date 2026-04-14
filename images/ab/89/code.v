module top_module(out, in);input [15:0] in;
	output [3:0] out;
	
	reg [3:0] out;
	
	always @ (in)
	begin
		out[0] = (in[3:0] + in[7:4] + in[11:8] + in[15:12]) >= 8;
		out[1] = (in[3:0] + in[7:4] + in[11:8] + in[15:12]) >= 8;
		out[2] = (in[3:0] + in[7:4] + in[11:8] + in[15:12]) >= 8;
		out[3] = (in[3:0] + in[7:4] + in[11:8] + in[15:12]) >= 8;
	end
endmodule