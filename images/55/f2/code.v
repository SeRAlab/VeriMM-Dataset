module top_module(
	output reg [WORD_WIDTH-1:0] A_data, B_data,
	input [WORD_WIDTH-1:0] D_data,
	input [2:0] AA, BA, DA,
	input RW, CLK
	);parameter WORD_WIDTH = 16;

reg [WORD_WIDTH-1:0] REGS[7:0];

always@(posedge CLK)
	if(RW)
		case(DA)
			3'b 000 : REGS[0] = D_data;
			3'b 001 : REGS[1] = D_data;
			3'b 010 : REGS[2] = D_data;
			3'b 011 : REGS[3] = D_data;
			3'b 100 : REGS[4] = D_data;
			3'b 101 : REGS[5] = D_data;
			3'b 110 : REGS[6] = D_data;
			3'b 111 : REGS[7] = D_data;
		endcase
		
always@(*)
	begin
		case(AA)
			3'b 000 : A_data = REGS[0];
			3'b 001 : A_data = REGS[1];
			3'b 010 : A_data = REGS[2];
			3'b 011 : A_data = REGS[3];
			3'b 100 : A_data = REGS[4];
			3'b 101 : A_data = REGS[5];
			3'b 110 : A_data = REGS[6];
			3'b 111 : A_data = REGS[7];
		endcase
		
		case(BA)
			3'b 000 : B_data = REGS[0];
			3'b 001 : B_data = REGS[1];
			3'b 010 : B_data = REGS[2];
			3'b 011 : B_data = REGS[3];
			3'b 100 : B_data = REGS[4];
			3'b 101 : B_data = REGS[5];
			3'b 110 : B_data = REGS[6];
			3'b 111 : B_data = REGS[7];
		endcase
	end
	
endmodule