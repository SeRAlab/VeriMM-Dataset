module top_module(clk,reset,q);input clk, reset;
output reg [0:4] q;

always @(negedge reset or posedge clk) begin
	if(~reset)
		q <= 5'b10111;
	else begin
		q[4] <= q[3];
		q[3] <= q[2];
		q[2] <= q[1];
		q[1] <= q[0];
		q[0] <= q[1]^q[4];
	end
end

endmodule