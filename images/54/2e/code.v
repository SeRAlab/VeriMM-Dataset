module top_module(c, r, q, cout);input c, r;
	output reg [3:0] q;
	output reg cout;
	
	always @(posedge c or posedge r) begin
		if (r) begin
			q <= 0;
			cout <= 0;
		end
		else begin
			if (q == 4'b1111) begin
				q <= 0;
				cout <= 1;
			end
			else begin
				q <= q + 1'b1;
				cout <= 0;
			end
		end
	end
endmodule