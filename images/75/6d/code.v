module top_module (
  input clk,
  input reset,
  input serial_in,
  output reg [7:0] parallel_out);always @(posedge clk or posedge reset) begin
	if (reset)
		parallel_out <= 8'b0;
	else
		parallel_out <= {parallel_out[6:0], serial_in};
end
endmodule