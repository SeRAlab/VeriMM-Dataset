module top_module(input clk,
				input rot_a, input rot_b, 
				output wire rot_dir, output wire rot_event_out);reg rot_a_latch = 0, rot_b_latch = 0;
	assign rot_dir = rot_b_latch, rot_event_out = rot_a_latch;
	always @(posedge clk) begin
		case ({rot_a, rot_b})
		2'b00: rot_a_latch <= 1;
		2'b11: rot_a_latch <= 0;
		2'b10: rot_b_latch <= 1;
		2'b01: rot_b_latch <= 0;
		endcase
	end
endmodule