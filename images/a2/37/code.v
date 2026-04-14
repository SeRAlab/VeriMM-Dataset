module top_module( clk_i, rst_n, rs1_i, rs1_o, rt2_i, rt2_o, instr_i, instr_o, Mem2Reg_i, Mem2Reg_o, RegWrite_i, RegWrite_o );input           clk_i;
input           rst_n;
input  [32-1:0] rs1_i;
input  [32-1:0] rt2_i;
input  [5-1:0] instr_i;
	
input  Mem2Reg_i;
input  RegWrite_i;


output reg [32-1:0] rs1_o;
output reg [32-1:0] rt2_o;
output reg [5-1:0] instr_o;
	
output reg Mem2Reg_o;
output reg RegWrite_o;   





     


always @( posedge clk_i  ) begin
    if(rst_n == 0) begin
		rs1_o <= 0;
		rt2_o <= 0;
		instr_o <= 0;
			
		Mem2Reg_o <= 0;
		RegWrite_o <= 0; 
	end
    else begin
		rs1_o <= rs1_i;
		rt2_o <= rt2_i;
		instr_o <= instr_i;
			
		Mem2Reg_o <= Mem2Reg_i;
		RegWrite_o <= RegWrite_i;  
	end
end

endmodule