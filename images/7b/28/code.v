module ring_counter(
	input wire clk,
	input wire reset,
	output reg [2:0] Q
);always @(posedge clk or posedge reset) begin
		if (reset)
			Q <= 3'b001;
		else
			Q <= {Q[1:0], Q[2]};
	end
endmodule