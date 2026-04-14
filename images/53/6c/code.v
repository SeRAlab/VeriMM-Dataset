module top_module(output reg [7:0] count, input clk, reset);reg [3:0] state; 
	reg [7:0] icount;
	always @(icount)
		count <= { icount[0], icount[1], icount[2], icount[3],
				icount[4], icount[5], icount[6], icount[7] };

	always @(posedge clk) begin
		if (reset == 1) begin
			state = 13;
		end
		
		case(state)
			0: begin icount <= 8'b00000010; state <= 1; end
			1: begin icount <= 8'b00000001; state <= 2; end
			2: begin icount <= 8'b00000100; state <= 3; end
			3: begin icount <= 8'b00000001; state <= 4; end
			4: begin icount <= 8'b00001000; state <= 5; end
			5: begin icount <= 8'b00000001; state <= 6; end
			6: begin icount <= 8'b00010000; state <= 7; end
			7: begin icount <= 8'b00000001; state <= 8; end
			8: begin icount <= 8'b00100000; state <= 9; end
			9: begin icount <= 8'b00000001; state <= 10;end
			10:begin icount <= 8'b01000000; state <= 11;end
			11:begin icount <= 8'b00000001; state <= 12;end
			12:begin icount <= 8'b10000000; state <= 13;end
			13,14,15:
			   begin icount <= 8'b00000001; state <= 0; end
		endcase
	end
endmodule