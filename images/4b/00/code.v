module buzzer_control(
	input c,
	input d,
	output reg buzz);always @(*) begin
    if (c == 1 || d == 1 || (c == 0 && d == 0)) buzz = 1;
    else buzz = 0;
end

endmodule