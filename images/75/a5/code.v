module top_module(
	input [2:0] Condition,
	input Branch,
	input RegWrite,
	input Less,Zero,Overflow,
	output reg BranchValid,RegWriteValid
);always @(*)
begin
if(Branch==0)
BranchValid=0;
else
begin
case(Condition)
3'b000:
BranchValid=0;
3'b001:
BranchValid=Zero;
3'b010:
BranchValid=~Zero;
3'b011:
BranchValid=Less|Zero;
3'b100:
BranchValid=Less;
3'b101:
BranchValid=~Less;
3'b110:
BranchValid=~(Less|Zero);
3'b111:
BranchValid=0;
endcase
end

if(RegWrite==0)
RegWriteValid=0;
else if(Overflow==1)
RegWriteValid=0;
else
RegWriteValid=1;
end

endmodule