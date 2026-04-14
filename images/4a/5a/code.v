module top_module(Clock, Reset, Return);input Clock;
	input Reset;
	output [15:0]Return;
	reg [15:0]Number;
	wire feed;
	
	assign feed = Number[0] ^ Number[2] ^ Number[3] ^ Number[5];
	
	always @(posedge Clock) begin
		if (Reset) begin
			Number = 16'hCAFE;
		end else begin
			Number = (Number >> 1) | (feed << 15);
		end
	end
	
	assign Return = Number;
endmodule