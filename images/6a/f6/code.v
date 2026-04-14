module shift_register (
	input clk,
	input data,
	output q);reg [3:0] stages = 4'b0000;

	always @(posedge clk) begin
		stages <= {stages[2:0], data};
	end
	
	assign q = stages[3];
	
endmodule