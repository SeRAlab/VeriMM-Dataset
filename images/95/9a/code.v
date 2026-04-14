module top_module(rst, clk, enable, out_1ms);input clk, rst, enable;
	reg [15:0] LFSR;
	output reg out_1ms;

	parameter 	CYCLE50K 	= 16'b0100001011001110,
			INIT		= 16'b1111111111111111;

	always @(posedge clk, negedge rst)
	begin
		if(rst == 0)
		begin
			LFSR <= INIT;
			out_1ms <= 0;
		end
		else	begin
			if(enable)	begin
				if(LFSR == CYCLE50K)	begin
					out_1ms <= 1;
					LFSR <= INIT;
				end
				else	begin
					LFSR[0] <= LFSR[1] ^ LFSR[2] ^ LFSR[4] ^ LFSR[15];
					LFSR[15:1] <= LFSR[14:0];
					out_1ms <= 0;
				end
			end
			else	begin
				LFSR <= INIT;
				out_1ms <= 0;
			end
		end
	end
endmodule