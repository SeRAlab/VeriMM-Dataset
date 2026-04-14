module binary_counter(
	input clk,
	input rst_n,
	input en,
	output reg [1:0] counter
);

	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			counter <= 2'b00;
		else if(en)
			counter <= counter + 1'b1;
	end
	
endmodule