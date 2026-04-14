module shift_register(
	input wire clk,
	input wire load,
	input wire [7:0] D,
	output reg [7:0] Q
);always @(posedge clk) begin
		if (load)
			Q <= D;
		else
			Q <= {1'b0, Q[7:1]};
	end
endmodule