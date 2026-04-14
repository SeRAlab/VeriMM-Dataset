module final_module(
	input d,
	input e,
	output reg f);always @(*) begin
    if (d == 1 || (d == 0 && e == 0)) f = 1;
    else f = 0;
end

endmodule