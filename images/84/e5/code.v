module shift_register (
        input clk,
        input areset,
        input load,
        input [3:0] d,
        output reg [3:0] q);always @(posedge clk or posedge areset) begin
	if (areset)
		q <= 4'b0000;
	else if (load)
		q <= d;
	else
		q <= {1'b0, q[3:1]};
end

endmodule