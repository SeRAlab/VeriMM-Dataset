module register (
  input clk,
  input clr_n,
  input load,
  input [7:0] d,
  output reg [7:0] q
);always @(posedge clk or negedge clr_n) begin
	if (!clr_n) begin
		q <= 8'b00000000;
	end else if (load) begin
		q <= d;
	end
end

endmodule