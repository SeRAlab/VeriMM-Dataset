module counter_3bit (
	input clk,
	input reset,
	output reg [2:0] count);

always @(posedge clk or posedge reset) begin
	if (reset)
		count <= 3'b001;
	else
		count <= count + 2;
	end

endmodule