module top_module(
	 input [5:0]op,
	 input PCSrc,
	 input [25:0] target_address,
    input branch,
    input [31:0] alu_out,
	 input [31:0] ex_imm,
	 input clk,
	 input rst_n,
    output reg [7:0]pc
    );reg [7:0] nextpc;
reg alu_zero;
reg alu_gz;
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		pc <= 0;
	else
		pc <= nextpc;
end


always@(*)
begin
	if(~PCSrc)
		if(branch)
		begin
			if(op == 6'b000111)
				if(alu_out > 0)
					nextpc[7:2] = pc[7:2] + 1'b1 + ex_imm[5:0];
				else	
					nextpc = pc + 4;
		end
		else
			nextpc = pc + 4;
	else
	begin
		nextpc[7:2] = target_address[5:0];
		nextpc[1:0] = 2'b00;
	end
end

endmodule