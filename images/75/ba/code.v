module top_module(
	input [15:0] PC,
	output [15:0] instruction
);wire [15:0] instructions [15:0];
	

		
		
		
		assign instructions[0] = 16'h8010;
		assign instructions[1] = 16'h2116;
		assign instructions[2] = 16'h2667;
		assign instructions[3] = 16'h2713;
		assign instructions[4] = 16'h2337;
		assign instructions[5] = 16'h2777;
		assign instructions[6] = 16'h2762;
		assign instructions[7] = 16'h6322;
		assign instructions[8] = 16'h2414;
		assign instructions[9] = 16'h7235;
		assign instructions[10] = 16'hE50C;
		assign instructions[11] = 16'hF00B;
		
	assign instruction = instructions[PC];
endmodule