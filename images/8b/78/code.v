module binary_counter (
  input clk,
  input en,
  input preset_n,
  input [3:0] preset_val,
  output reg [3:0] count
);always @(posedge clk or negedge preset_n) begin
	if (!preset_n) begin
		count <= preset_val;
	end else if (en) begin
		count <= count + 1;
	end
end

endmodule