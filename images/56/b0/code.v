module control_signal(
	input p,
	input q,
	output reg sig);always @(*) begin
    if (p == 1 && q == 0) sig = 1;
    else sig = 0;
end

endmodule