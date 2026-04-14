module johnson_counter (
	input clk,
	input reset,
	output reg [2:0] count
);

always @(posedge clk or posedge reset) begin
	if (reset)
		count <= 3'b001;
	else
		count <= {~count[2], count[2:1]};
end

endmodule