module ring_counter (
  input clk,
  input reset,
  output reg [4:0] q
);always @(posedge clk) begin
	if (reset) begin
		q <= 5'b10000;
	end else begin
		q <= {q[0], q[4:1]};
	end
end

endmodule