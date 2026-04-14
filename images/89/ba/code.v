module top_module(out, clk, rstn, in);output reg out;
	input clk;
	input rstn;
	input in;
	reg [4:0] taps;
	reg result;
	
 
	always @(posedge clk or negedge rstn) begin
		if(rstn == 0) begin
			taps <= 0;
			out <= 0;
		end else begin
			taps[4] <= taps[3];
			taps[3] <= taps[2];
			taps[2] <= taps[1];
			taps[1] <= taps[0];
			taps[0] <= in;
			if(taps[2] & taps[3] & taps[4])
				out <= 1;
			if(~taps[2] & ~taps[3] & ~taps[4])
				out <= 0;
		end
	end
endmodule