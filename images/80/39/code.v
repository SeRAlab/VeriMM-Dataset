module fan_control(
	input u,
	input v,
	output reg fan);always @(*) begin
    if (u == 0 && v == 1) fan = 1;
    else fan = 0;
end

endmodule