module shift_register (
  input clk,
  input reset,
  input load,
  input shift,
  input [3:0] d,
  output reg [3:0] q
);always @(posedge clk) begin
	if (reset) begin
		q <= 4'b0000;
	end else if (load) begin
		q <= d;
	end else if (shift) begin
		q <= {1'b0, q[3:1]};
	end
end

endmodule