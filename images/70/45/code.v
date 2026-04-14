module top_module(input clk, rst, WB_EN_in, memory_Read_en_in, memory_write_en_in,input [31 : 0] ALU_Res_in, Val_Rm_in,input [3:0] Dest_in,output reg WB_EN_out, memory_read_en_out, memory_write_en_out,output reg [31 : 0] ALU_Res_out, Val_Rm_out,output reg [3:0] Dest_out);always @(posedge clk) begin
		if(rst) begin WB_EN_out <= 0;memory_read_en_out <= 0;memory_write_en_out <= 0;ALU_Res_out <= 0;Val_Rm_out <= 0;Dest_out <= 0;end 
		else begin WB_EN_out <= WB_EN_in; memory_read_en_out <= memory_Read_en_in; memory_write_en_out <= memory_write_en_in; ALU_Res_out <= ALU_Res_in; Val_Rm_out <= Val_Rm_in; Dest_out <= Dest_in; end
	end
endmodule