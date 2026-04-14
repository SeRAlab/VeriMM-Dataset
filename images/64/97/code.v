module top_module(
	input CLK,
	input RST,
	output reg [7:0] PIXEL = 0,
	output reg [7:0] BIT = 0,
	output reg [7:0] NS = 0,
	output reg DONE
);parameter PIXELS = 256;
parameter BITS = 24;
parameter NSS = 64;

always @(posedge CLK) begin
	if(RST) begin
		BIT <= 0;
		PIXEL <= 0;
		NS <= 0;
		DONE <= 0;
	end else
	if(NS+1 == NSS) begin
		NS <= 0;
		if((BIT+1 == BITS)) begin
			BIT <= 0;
			if(PIXEL+1 != PIXELS) PIXEL <= PIXEL + 1;
			end else BIT <= BIT + 1;
	end else NS <= NS + 1;

	if((PIXEL+1 == PIXELS) & (BIT+1 == BITS))
		DONE <= 1;
end
endmodule