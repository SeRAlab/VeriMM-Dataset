module motor_control(
	input r,
	input s,
	output reg motor);always @(*) begin
    if ((r == 1 && s == 0) || (r == 0 && s == 0)) motor = 1;
    else motor = 0;
end

endmodule