module top_module(EX_MEMRegWrite,MEM_WBRegWrite,EX_MEMRegisterRd,MEM_WBRegisterRd,ID_EXRegisterRs,ID_EXRegisterRt,ForwardA,ForwardB);input EX_MEMRegWrite,MEM_WBRegWrite;
input [4:0] EX_MEMRegisterRd,MEM_WBRegisterRd,ID_EXRegisterRs,ID_EXRegisterRt;
output reg [1:0] ForwardA,ForwardB;

always@(*)begin
	if(EX_MEMRegWrite 
		&& (EX_MEMRegisterRd!=0) 
		&& ( EX_MEMRegisterRd == ID_EXRegisterRs)) begin
		ForwardA = 2'b10;
	end
	else if(MEM_WBRegWrite 
		&& (MEM_WBRegisterRd!=0)
		&& (EX_MEMRegisterRd!=ID_EXRegisterRs)
		&& (MEM_WBRegisterRd==ID_EXRegisterRs) )begin
		ForwardA = 2'b01;
	end
	else begin
		ForwardA = 2'b00;
	end

	if(EX_MEMRegWrite 
		&& (EX_MEMRegisterRd!=0) 
		&& ( EX_MEMRegisterRd == ID_EXRegisterRt)) begin
		ForwardB = 2'b10;
	end
	else if(MEM_WBRegWrite 
		&& (MEM_WBRegisterRd!=0)
		&& (EX_MEMRegisterRd!=ID_EXRegisterRt)
		&& (MEM_WBRegisterRd==ID_EXRegisterRt) )begin
		ForwardB = 2'b01;
	end
	else begin
		ForwardB = 2'b00;
	end

end


endmodule