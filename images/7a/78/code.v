module yet_another_module (
	input clock,
	input n, 
	output reg i,
	output reg j);always @(negedge clock)
		i <= n;
		
	always @(posedge clock)
		j <= n;
endmodule