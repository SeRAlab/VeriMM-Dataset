module top_module(out, in, enable, clk, reset_val, reset_button);input[31:0] in, reset_val;
input enable, clk, reset_button;
output wire[31:0] out;

reg[31:0] val;

always @(posedge clk) begin
	
	if (reset_button) begin
		val = reset_val;
	end
	else if(!reset_button) begin
		if (enable) begin
			val = in;
		end
	end
end

assign out = val;endmodule