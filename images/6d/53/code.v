module johnson_counter (
        input clk,
        input areset,
        output reg [2:0] q);always @(posedge clk or posedge areset) begin
	if (areset)
		q <= 3'b000;
	else
		q <= {~q[2], q[2:1]};
end

endmodule