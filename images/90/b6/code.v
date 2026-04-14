module top_module(S_in, S_out);input [23:0] S_in;
	output [23:0] S_out;

	reg [23:0] temp;
	reg [23:0] reminder;
	always @(S_in) begin
		temp = (S_in >> 1) + (S_in >> 2);
		temp = temp + (temp >> 4);
		temp = temp + (temp >> 8);
		temp = temp >> 3;
		reminder = S_in - (((temp << 2) + temp) << 1);
	end
	assign S_out = reminder >= 5? temp + 1: temp;
endmodule