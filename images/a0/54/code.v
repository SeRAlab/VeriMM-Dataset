module top_module(
input Ctr,
input [15:0]imm_16,
output reg[31:0]imm_32
);always @(Ctr or imm_16)
begin 
	if (imm_16[15]&&Ctr)
		imm_32={16'hffff,imm_16};
	else 
		imm_32={16'h0,imm_16};
end 
endmodule