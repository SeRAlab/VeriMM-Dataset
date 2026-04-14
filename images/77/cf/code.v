module top_module(W_S, out);input W_S;
	output [16:0] out;
	reg [16:0] disp;
	always@(*)
	begin
		if(W_S) begin
			disp[16:0] = 17'b01010101010101010;
		end
		else begin
			disp[16:0] = 17'b00000000000000000;
		end
	end
	assign out = disp;endmodule