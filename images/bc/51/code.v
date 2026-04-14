module top_module(in, out);input wire[4: 0] in;
	output wire[5: 0] out;
	reg[3: 0] lsb;
	reg[1: 0] msb;
	integer i;
	always @(in) begin
		msb = 2'b00;
		lsb = 4'b0000;
		for(i = 4; i >= 0; i = i - 1) begin
			if(lsb >= 5) begin
				lsb = lsb + 3;
			end
			msb = msb << 1;
			msb[0] = lsb[3];
			lsb = lsb << 1;
			lsb[0] = in[i];
		end
	end
	assign out = {msb, lsb};
endmodule