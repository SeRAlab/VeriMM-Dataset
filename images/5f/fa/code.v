module behavior_module(
	input m,
	input n,
	output reg signal);always @(*) begin
    if ((m == 1 && n == 1) || (m == 0 && n == 0)) signal = 1;
    else signal = 0;
end

endmodule