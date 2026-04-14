module counter (
        input clk,
        input areset,
        input en,
        output reg [3:0] q);always @(posedge clk or posedge areset) begin
	if (areset)
		q <= 4'b0000;
	else if (en)
		q <= q + 1;
end

endmodule