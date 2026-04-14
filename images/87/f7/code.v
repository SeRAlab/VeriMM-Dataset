module light_control(
	input i,
	input j,
	output reg light);always @(*) begin
    if (i == 1 && j == 1) light = 0;
    else light = 1;
end

endmodule