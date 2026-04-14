module top_module(
input CLK,
input SLOWCLK,
input RESET,
output EN_OUT
    );reg internal_rst;
	reg cur;

	always @(posedge CLK)
	begin
		if (RESET == 1'b1)
		begin
			cur <= 1'b0;
			internal_rst <= 1'b0;
		end
		else
		begin
			if (SLOWCLK == cur) 
			begin
				cur <= ~cur;
				internal_rst <= 1'b1;
			end
			else if (internal_rst == 1'b1)
			begin
				internal_rst <= 1'b0;
			end
		end
	end

	assign EN_OUT = internal_rst;

endmodule