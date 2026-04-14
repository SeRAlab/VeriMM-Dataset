module top_module(
	input clk,sclr,
	input first,sub,
	input a,b,
	output sum
);reg car;
assign sum = a ^ (sub ^ b) ^ (first ? sub : car);

always @(posedge clk) begin
	if (sclr) car <= 1'b0;
	else car <= a & (sub ^ b) |
				a & (first ? sub : car) |
				(sub ^ b) & (first ? sub : car);
end

endmodule