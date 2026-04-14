module binary_counter (
  input clk,
  input clear,
  input en,
  output reg [2:0] count,
  output carry
);always @(posedge clk) begin
	if (clear) begin
		count <= 3'b000;
	end else if (en) begin
		count <= count + 1;
	end
end

assign carry = (count == 3'b111);

endmodule