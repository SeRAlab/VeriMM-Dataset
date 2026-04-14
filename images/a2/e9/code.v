module top_module(
	input wire clk,
	input wire [N-1:0] match,
	output reg signal = 1'd0
);parameter N = 32;
reg [N-1:0] count = {N{1'd0}};

always @(posedge clk) begin
	if (count == match) begin
		count <= {N{1'd0}};
		signal <= ~signal;
	end else begin
		count <= count + 1;
	end
end

endmodule