module top_module(
	input clk,
	input reset,
	input baud_clk,
	input data_strobe,
	input [7:0] data,
	output ready,
	output reg serial_txd
);reg [8:0] shift;
	reg [3:0] bits;
	reg baud_clk_prev;

	
	assign ready = bits == 0;

	always @(posedge clk)
	begin
		baud_clk_prev <= baud_clk;

		if (reset)
		begin
			bits <= 0;
			serial_txd <= 1; 
		end else
		if (ready && data_strobe)
		begin
			
			
			shift <= { data, 1'b0 };
			bits <= 10 + 1;
		end else
		if (bits != 0 && baud_clk && !baud_clk_prev)
		begin
			
			
			bits <= bits - 1;
			serial_txd <= shift[0];
			shift <= { 1'b1, shift[8:1] };
		end
	end
endmodule