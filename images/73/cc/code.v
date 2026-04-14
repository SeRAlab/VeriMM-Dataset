module top_module(
		input wire clk,
		input wire Dis,
		output reg d
    );always @ ( Dis )
		begin
			d <= Dis * 170;
		end
endmodule