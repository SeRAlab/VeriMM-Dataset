module led_control(
	input x,
	input y,
	output reg LED);always @(*) begin
    if ((x == 1 && y == 1) || (x == 0 && y == 1)) LED = 1;
    else LED = 0;
end

endmodule