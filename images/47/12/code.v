module complex_module(
	input j,
	input k,
	output reg l);always @(*) begin
    if (j == 1 || (j == 0 && k == 0)) l = 1;
    else l = 0;
end

endmodule