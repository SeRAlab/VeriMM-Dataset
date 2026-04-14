module top_module(
	input clk,
	input  [17:0] d_in,
	input strobe,
	output [17:0] d_out
);parameter span=6;


reg signed [17:0] d_last=0, diff=0;
always @(posedge clk) if (strobe) begin
	d_last <= d_in;
	diff <= d_in - d_last;
end


reg signed [17+span:0] i1=0;
always @(posedge clk) begin
	i1 <= i1+diff;
end
assign d_out = i1[17+span:span];

endmodule