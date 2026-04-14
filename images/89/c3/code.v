module gray_counter (
  input clk,
  output reg [2:0] gray_count);always @(posedge clk) begin
		gray_count <= (gray_count >> 1) ^ gray_count + 1;
	end
endmodule