module top_module( CLK, IN_REG, IN_DAT);parameter	in_width = 7;

input			CLK;
input	 [in_width:0]	IN_REG;

output	 reg	[in_width:0]	IN_DAT;

reg		 [in_width:0]	meta_reg;

	always @(posedge CLK)
		begin
			meta_reg <= IN_REG;
			IN_DAT   <= meta_reg;
		end

endmodule