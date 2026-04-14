module another_logic(
	input g,
	input h,
	output reg i);always @(*) begin
    if (g == 0) i = 1;
    else i = 0;
end

endmodule