module down_counter(
	input clk,
	input load,
	input [5:0] data,
	output reg [5:0] q);always @(posedge clk) begin
    if (load)
        q <= 6'b101010;
    else
        q <= q - 1;
end
endmodule