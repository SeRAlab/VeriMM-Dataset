module top_module(
	input  clk, 
	input  rst_n, 
	input  [6:0] pressed, 
	output reg [19:0] note_div
);reg [19:0] next_note_div = 20'b0;
	
	always @(*) 
	begin
	note_div <= next_note_div;
		case(pressed)
			7'b0000001: next_note_div <= 20'd76336;
			7'b0000010: next_note_div <= 20'd68027;
			7'b0000100: next_note_div <= 20'd60606;
			7'b0001000: next_note_div <= 20'd57307;
			7'b0010000: next_note_div <= 20'd51020;
			7'b0100000: next_note_div <= 20'd45455;
			7'b1000000: next_note_div <= 20'd40486;
			default:    next_note_div <= 20'd0;
		endcase
	end

endmodule