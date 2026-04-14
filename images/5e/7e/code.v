module specific_module(
	input r,
	input s,
	output reg t);always @(*) begin
    t = r ^ s;
end

endmodule