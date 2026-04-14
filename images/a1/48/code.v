module top_module(
						input [7:0]channel,
						input en1,
						input en2,
						input en3,
						input en4,
						input en5,
						input en6,
						input en7,
						input en8,
						input en9,
						input en10,
						input en11,
						input en12,
						input en13,
						input en14,
						input en15,
						input en16,
						input en17,
						input en18,
						input en19,
						output reg en_out
					);always @(*)
begin
	case(channel)
		8'd0: en_out = en1;
		8'd1: en_out = en2;
		8'd2: en_out = en3;
		8'd3: en_out = en4;
		8'd4: en_out = en5;
		8'd5: en_out = en6;
		8'd6: en_out = en7;
		8'd7: en_out = en8;
		8'd8: en_out = en9;
		8'd9: en_out = en10;
		8'd10: en_out = en11;
		8'd11: en_out = en12;
		8'd12: en_out = en13;
		8'd13: en_out = en14;
		8'd14: en_out = en15;
		8'd15: en_out = en16;
		8'd16: en_out = en17;
		8'd17: en_out = en18;
		8'd18: en_out = en19;
		default:
				en_out <= 1'b0;
		endcase	
end	

endmodule