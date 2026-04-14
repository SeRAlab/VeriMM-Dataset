module top_module(clk, rst_, data, addr, cs_, oe_, we_, interrupt);input clk;
	input rst_;
	inout [7:0] data;
	input [7:0] addr;
	input cs_;
	input oe_;
	input we_;
	output interrupt;
	
	reg [7:0] r[0:7];
	reg [31:0] counter;
	
	// Provide read support of memory
	assign data = (~cs_ & ~oe_) ? r[addr] : 8'bzzzzzzzz;

	always @(posedge clk) begin
		if (rst_ == 1'b1) begin
			{ r[3], r[2], r[1], r[0] } <= 32'd0;
			{ r[7], r[6], r[5], r[4] } <= 32'd0;
			counter <= 32'd0;
		end
		else begin
			if (~cs_ & ~we_) begin
				r[addr] <= data;
			end
			else begin
				{ r[3], r[2], r[1], r[0] } <= counter[3:0];
				{ r[7], r[6], r[5], r[4] } <= counter[7:4];
				counter <= counter + 32'd1;
			end
		end
	end
	
	assign interrupt = ( { r[7], r[6], r[5], r[4] } == 32'd0 ) ? 1'b1 :
						(( { r[3], r[2], r[1], r[0] } >= { r[7], r[6], r[5], r[4] } ) ? 1'b1 : 1'b0);
		
endmodule