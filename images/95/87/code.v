module top_module(
	clk,rst,interrupt_signal,cp_oper,cp_cd,return_addr,GPR,jump_en,CPR,jump_addr
	
    );input clk,rst;
	input [1:0] interrupt_signal;
	input [1:0] cp_oper;
	input [4:0] cp_cd;
	input [31:0] return_addr,GPR;
	output jump_en;
	output [31:0] CPR;
	output [31:0] jump_addr;
	
	reg [31:0] mem [31:0];
	
	wire inter;
	assign inter=|interrupt_signal;
	always @(negedge clk or posedge rst or posedge inter)
	begin
		if(rst)
			begin
				mem[0] <=32'b0;mem[1] <=32'b0;mem[2] <=32'b0;mem[3] <=32'b0;
				mem[4] <=32'b0;mem[5] <=32'b0;mem[6] <=32'b0;mem[7] <=32'b0;
				mem[8] <=32'b0;mem[9] <=32'b0;mem[10]<=32'b0;mem[11]<=32'b0;
				mem[12]<=32'b0;mem[13]<=32'b0;mem[14]<=32'b0;mem[15]<=32'b0;
				mem[16]<=32'b0;mem[17]<=32'b0;mem[18]<=32'b0;mem[19]<=32'b0;
				mem[20]<=32'b0;mem[21]<=32'b0;mem[22]<=32'b0;mem[23]<=32'b0;
				mem[24]<=32'b0;mem[25]<=32'b0;mem[26]<=32'b0;mem[27]<=32'b0;
				mem[28]<=32'b0;mem[29]<=32'b0;mem[30]<=32'b0;mem[31]<=32'b0;
				
			end
		else if(inter)
		begin
			mem[13] <= {30'b0,interrupt_signal};
			mem[14] <= return_addr;
		end
		else if(cp_oper[0])
			mem[cp_cd]<=GPR;
	end
	
	assign CPR = mem[cp_cd];
	assign jump_en = inter | cp_oper[1];
	assign jump_addr = (inter)?mem[1]:mem[14];
	
endmodule