module loadable_counter(
	input clk,
	input rst_n,
	input load,
	input [3:0] data,
	output reg [3:0] count
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			count <= 4'b0000;
		else if (load)
			count <= data;
		else
			count <= count + 1;
	end
	
endmodule