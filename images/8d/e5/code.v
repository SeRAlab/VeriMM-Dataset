module pipo_shift_register(
	input clk,
	input load,
	input [7:0] d,
	output reg [7:0] q
);

	always@(posedge clk) begin
		if(load)
			q <= d;
		else
			q <= {q[6:0], q[7]};
	end
	
endmodule