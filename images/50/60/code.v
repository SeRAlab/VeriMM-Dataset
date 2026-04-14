module edge_detector (
	input clk,
	input rst,
	input signal_in,
	output reg pulse_out
);

reg signal_in_d;

always @(posedge clk or posedge rst)
begin
	if (rst) begin
		signal_in_d <= 0;
		pulse_out <= 0;
	end else begin
		pulse_out <= signal_in & ~signal_in_d;
		signal_in_d <= signal_in;
	end
end

endmodule