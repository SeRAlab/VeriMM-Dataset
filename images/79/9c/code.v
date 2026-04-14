module top_module(clk, rst_n, in, out);input clk, rst_n, in;
output out;

reg net;

always @(posedge clk)
begin
		if (!rst_n)
			net <= 1'b1;
		else
			net <= in;
end

assign out = (~net && in);

endmodule