module top_module(
Inst, 
PCPlus4,
PCSrc,
JmpAddr,
ResumeAddr,
reset
    );input [31:0] Inst;
input [31:0] PCPlus4, ResumeAddr;
input reset;

output PCSrc;
reg PCSrc;
output [31:0] JmpAddr;



	
always @ (Inst[31:26], reset)
begin
		if(reset)
			PCSrc <= 1'b0;
		else if (Inst[31:26] == 6'h2 || Inst[31:26] == 6'h3)
			PCSrc <= 1'b1;
		else
			PCSrc <= 1'b0;	
end

assign JmpAddr = (Inst[31:26] == 6'h2)?({{6{Inst[25]}},Inst[25:0]}):((Inst[31:26] == 6'h3)?(ResumeAddr):(PCPlus4));

endmodule