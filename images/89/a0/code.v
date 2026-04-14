module top_module(op, leds);input op;
	output reg [0:6] leds;
	
	always @(op)
		if (op == 0) begin
			leds = 7'b1111000; 
		end else begin 
			leds = 7'b1111110; 
		end

endmodule