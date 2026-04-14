module top_module(
		input clk,
		input rst,
		input WB_en_in,
		
		input MEM_R_EN_in,
		input MEM_W_EN_in,

		input [31:0] ALU_result_in,
		input [31:0] ST_val_in,
		input [4:0] Dest_in,

		input freeze,

		output reg WB_en,
		
		output reg MEM_R_EN,
		output reg MEM_W_EN,
		output reg [31:0] ALU_result,
		output reg [31:0] ST_Val,
		output reg [4:0] Dest
	);always@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			WB_en <= 0;
			MEM_R_EN <= 0;
			MEM_W_EN <= 0;
			ALU_result <= 0;
			ST_Val <= 0;
			Dest <= 0;
		end
		else if(!freeze) begin
			WB_en <= WB_en_in;
			MEM_R_EN <= MEM_R_EN_in;
			MEM_W_EN <= MEM_W_EN_in;
			ALU_result <= ALU_result_in;
			ST_Val <= ST_val_in;
			Dest <= Dest_in;
		end
	end
endmodule