module top_module(Bus_in, clk, reset, r_in, r_out, Bus_out);input Bus_in, clk, reset, r_in, r_out;
	output Bus_out;
	reg [0:0] reg_data;

	always @(posedge clk, posedge reset) begin
		if (reset) begin
			reg_data <= 1'b0;
		end else if (r_in) begin
			reg_data <= Bus_in;
		end
	end

	assign Bus_out = r_out ? reg_data : 1'b0;

endmodule