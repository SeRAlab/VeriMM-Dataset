module top_module(inp,s1,s2,ot);input inp,s1,s2;
	output ot;
	reg out = 0;
	reg[0:1] state = 00;
	always @(s1 != state[0] or s2 != state[1])
	begin
		state <= {s1,s2};
		case({s1,s2,inp})
			3'b000: out <= 0;
			3'b001: out <= 1;
			3'b010: out <= 0;
			3'b011: out <= 0;
			3'b100: out <= 0;
			3'b101: out <= 0;
			3'b110: out <= 1;
			3'b111: out <= 0;
		endcase
	end
	assign ot = out;endmodule