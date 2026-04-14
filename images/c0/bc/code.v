module ramp_a_tone ( input rst, input clk, output reg [15:0] tone );
	reg up;
	always @(posedge rst or posedge clk) begin
		if( rst ) begin
			up   <= 0;
			tone <= 0;
		end
		else begin
			if( tone == 16'hFFFE ) begin
				up <= 1'b0;
			end
			else if( tone == 16'h1 ) begin
				up <= 1'b1;
			end
			tone <= up ? (tone+1'b1) : (tone-1'b1);
		end
	end
endmodule