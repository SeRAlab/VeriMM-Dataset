module lfsr_5bit(
	input clk,
	input rst,
	output reg [4:0] q
);

	wire feedback;
	assign feedback = q[4] ^ q[2];

	always@(posedge clk or posedge rst) begin
		if(rst)
			q <= 5'b00001;
		else
			q <= {q[3:0], feedback};
	end
	
endmodule