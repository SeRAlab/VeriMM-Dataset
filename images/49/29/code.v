module top_module(
	input [7:0] PC,
	input Reset,
	output [7:0] Instruction_Code
    );reg [7:0] Mem [15:0];
	assign Instruction_Code = Mem[PC];
	
	always@(posedge Reset)
	begin
		if(Reset == 1)
		begin
			Mem[0] = 8'h2b;
			Mem[1] = 8'h6a;
			Mem[2] = 8'h63;
			Mem[3] = 8'hc1;
			Mem[4] = 8'h14;
			Mem[5] = 8'h55;
		end
	end

endmodule