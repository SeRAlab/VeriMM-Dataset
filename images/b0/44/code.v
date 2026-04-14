module up_down_counter(
	input clk,
	input rst_n,
	input up_down,
	output reg [3:0] counter
);

	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			counter <= 4'b0000;
		else if(up_down)
			counter <= counter + 1'b1;
		else
			counter <= counter - 1'b1;
	end
	
endmodule