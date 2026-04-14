module signal_control(
	input a,
	input b,
	output reg out);always @(*) begin
    if ((a == 1 && b == 0) || (a == 0 && b == 1)) out = 1;
    else out = 0;
end

endmodule