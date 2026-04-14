module signal_manager(
	input t,
	input u,
	output reg output_signal);always @(*) begin
    if (t == 1 && u == 1) output_signal = 1;
    else output_signal = 0;
end

endmodule