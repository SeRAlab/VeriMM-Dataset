module top_module(rst_n, trig, en, d, q);input rst_n, trig, en;
input [31:0] d;
output reg [31:0] q;

always @(negedge rst_n or posedge trig)
begin
	if (~rst_n)
		q <= 32'b0;
	else
	begin
		if (en)
			q <= d;
		else
			q <= q;
	end
end

endmodule