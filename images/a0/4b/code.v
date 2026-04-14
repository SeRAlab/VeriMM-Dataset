module top_module(CLK, RegW, RESET, DR, SR1, SR2, Reg_in, ReadReg1, ReadReg2);input CLK, RegW, RESET;
	input [3:0] DR, SR1, SR2;	 
	input [31:0] Reg_in;
	output [31:0] ReadReg1, ReadReg2;
	reg [31:0] REG[0:31];
	assign ReadReg1 = REG[SR1];
	assign ReadReg2 = REG[SR2];
	integer i;
	always@(posedge CLK, posedge RESET) begin
		if (RESET) begin
			for (i=0; i<32; i=i+1) begin
				REG[i] = 0;
			end
		end
		else begin
			if(RegW==1'b1) begin
				REG[DR] <= Reg_in[31:0];
			end
		end
	end
endmodule