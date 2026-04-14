module top_module(reset, c, cout, q);input reset, c;
output reg cout;
output reg [3:0]q;

always @(posedge reset or posedge c) begin
	if (reset) {cout, q} <= 0;
	else begin
		if (q == 9)
			{cout, q} <= {5'b10000};
		else 
			{cout, q} <= q + 1'b1;
	end
end
endmodule