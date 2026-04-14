module top_module (
	input [1:0] binary,
	output reg [3:0] one_hot);

always @(*) begin
	one_hot = 4'b0001 << binary;
end

endmodule