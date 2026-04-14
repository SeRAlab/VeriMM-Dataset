module special_module(
	input e,
	input f,
	output reg g);always @(*) begin
    if (e == f) g = 0;
    else g = 1;
end

endmodule