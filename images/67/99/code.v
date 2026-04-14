module top_module(tz, acumulador, out, clock);input wire clock;
	input wire [3:0] acumulador, tz;
	output reg [3:0] out;
	
	parameter CLEAR = 4'd0;
	parameter LOAD = 4'd1;
	parameter HOLD = 4'd2;
	
	always@(posedge clock)
	begin
		case(tz)
			CLEAR: out <= 4'd0;
			LOAD: out <= acumulador;
			
			default;
		endcase
	end
	
endmodule