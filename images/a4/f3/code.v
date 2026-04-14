module top_module(
		input wire		[ 7 : 0]	pc,
		output reg		[15 : 0]	instruction
    );/* ROM subsystem emulation */
	always @(pc) begin
		case(pc)
			8'h00:	instruction = 16'h7f00;	/* start:	ldi 0 */
			8'h01:	instruction = 16'h0100;	/* 			sto 0x00 */
			8'h02:	instruction = 16'h0101;	/* 			sto 0x01 */
			8'h03:	instruction = 16'h7200;	/* loop:	inc */
			8'h04:	instruction = 16'h74ff;	/* 			cmp 0xff */
			8'h05:	instruction = 16'h0a0c;	/* 			jz loop_e */
			8'h06:	instruction = 16'h0101;	/* 			sto 0x01 */
			8'h07:	instruction = 16'h0000;	/* 			add 0x00 */
			8'h08:	instruction = 16'h0100;	/* 			sto 0x00 */
			8'h09:	instruction = 16'h01ff;	/*			sto 0xff */
			8'h0a:	instruction = 16'h0201;	/* 			lo 0x01	*/
			8'h0b:	instruction = 16'h0303;	/* 			jmp loop */
			8'h0c:	instruction = 16'h030c;	/* self:	jmp self */
			default:
				begin
					instruction = 16'hffff;	/* end: 	halt */
				end
		endcase
	end

endmodule