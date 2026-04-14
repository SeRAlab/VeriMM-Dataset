module RAM4kx8(input CLK, input[11:0] AB, input CS, input READ, output[7:0] DO, input[7:0] DI);
	reg[7:0] mem[0:4095];
	reg[7:0] R;
	assign DO = CS? R: 8'bZ;
	always @(posedge CLK) if (CS) if (READ) R <= mem[AB]; else mem[AB] <= DI;
endmodule