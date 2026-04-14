module top_module( output reg [15:0] A_Data, B_Data, input [15:0] D_Data, input [2:0] AA, BA, DA, input RW, CLK );reg [15:0] REGS[7:0];

always@(posedge CLK)
	if(RW)
		case(DA)
		    3'b 000 : REGS[0] = D_Data;
			 3'b 001 : REGS[1] = D_Data;
			 3'b 010 : REGS[2] = D_Data;
			 3'b 011 : REGS[3] = D_Data;
			 3'b 100 : REGS[4] = D_Data;
			 3'b 101 : REGS[5] = D_Data;
			 3'b 110 : REGS[6] = D_Data;
			 3'b 111 : REGS[7] = D_Data;
		endcase
		
always@(*)
	begin
		case(AA)
		    3'b 000 : A_Data = REGS[0];
			 3'b 001 : A_Data = REGS[1];
			 3'b 010 : A_Data = REGS[2];
			 3'b 011 : A_Data = REGS[3];
			 3'b 100 : A_Data = REGS[4];
			 3'b 101 : A_Data = REGS[5];
			 3'b 110 : A_Data = REGS[6];
			 3'b 111 : A_Data = REGS[7];
		endcase
		
		case(BA)
		    3'b 000 : B_Data = REGS[0];
			 3'b 001 : B_Data = REGS[1];
			 3'b 010 : B_Data = REGS[2];
			 3'b 011 : B_Data = REGS[3];
			 3'b 100 : B_Data = REGS[4];
			 3'b 101 : B_Data = REGS[5];
			 3'b 110 : B_Data = REGS[6];
			 3'b 111 : B_Data = REGS[7];
		endcase
	end
	
endmodule