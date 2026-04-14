module shift_register(
	input clk,
	input reset,
	input load,
	input [11:0] data,
	output reg [11:0] q);always @(posedge clk) begin
    if (reset)
        q <= 12'b000000000000;
    else if (load)
        q <= data;
    else
        q <= {1'b0, q[11:1]};
end
endmodule