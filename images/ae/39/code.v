module top_module(
	input BranchControl,
	input ID_EX_MemRead,
	input [4:0] ID_EX_RegisterRt,
	input [4:0] IF_ID_RegisterRs,
	input [4:0] IF_ID_RegisterRt,

	output reg Stall,
	output reg Flush
);always @(
		BranchControl,
		ID_EX_MemRead,
		ID_EX_RegisterRt,
		IF_ID_RegisterRs,
		IF_ID_RegisterRt
	) 
	begin
		if 
		(
			ID_EX_MemRead &&
			((ID_EX_RegisterRt == IF_ID_RegisterRs) || (ID_EX_RegisterRt == IF_ID_RegisterRt))
		) 
		begin
			Stall <= 1;
		end
		else
		begin
			Stall <= 0;
		end

		
		
		Flush <= BranchControl;
	end

endmodule