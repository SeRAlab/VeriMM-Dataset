module different_module(
	input m,
	input n,
	output reg o);always @(*) begin
    if (m == 0 && n == 1) o = 1;
    else o = 0;
end

endmodule