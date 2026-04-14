module top_module(
	input clk,
	input reset,
	input PCWrite,
	input PCSrc,
	input[31:0] pc,
	output reg[31:0] pc_out,
	input[31:0] inst,
	input InstWrite,
	input nop,
	input[31:0] ExtImm,
	input[3:0] WriteAddrE,
	input RegWriteE,
	input[31:0] ALUResultE,
	output reg[31:0] instD
	);always @ (negedge clk)
	begin
		if (reset)	pc_out <= 'h00000000;
	else
		begin
			if (PCWrite == 1'b1)
			begin
				if (PCSrc == 1'b1)
					pc_out <= pc + 32'd4 + ExtImm;
				else if (WriteAddrE == 4'b1111 && RegWriteE == 1'b1)
					pc_out <= ALUResultE;
				else
					pc_out <= pc + 'd4;
			end
		end
	end
	
	always @ (negedge clk)
	begin
		if (reset) instD <= 32'b00000000000000000000000000000000;	
		else
		begin
			if (InstWrite)
				instD <= inst;
			if (nop)
				instD <= 32'b11100010100001000100000000000000;	
		end
	end


endmodule