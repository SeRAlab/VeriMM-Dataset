module top_module(clock, enable, in, out);input clock;
	input enable;
	input wire[7:0] in;
	output reg[127:0] out;
	
	wire en_clock;
	assign en_clock = clock && enable;

	always @(posedge en_clock) begin
		out = out << 8;
		out[7:0] = in;
	end


endmodule