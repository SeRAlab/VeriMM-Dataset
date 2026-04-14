module top_module(
value,
note_div
    );input [3:0] value;
output reg [19:0] note_div;

always@(value)
begin
	case(value)
		4'd10: note_div = 20'd181818;
		4'd0: note_div = 20'd163265;
		4'd1: note_div = 20'd153256;
		4'd2: note_div = 20'd136518;
		4'd3: note_div = 20'd121212;
		4'd4: note_div = 20'd114613;
		4'd5: note_div = 20'd102040;
		4'd6: note_div = 20'd90909;
		4'd7: note_div = 20'd80971;
		4'd8: note_div = 20'd76628;
		4'd9: note_div = 20'd68027;
		4'd11: note_div = 20'd60606;
		4'd12: note_div = 20'd57306;
		4'd13: note_div = 20'd51020;
		4'd14: note_div = 20'd45454;
		4'd15: note_div = 20'd40485;
	endcase
end

endmodule