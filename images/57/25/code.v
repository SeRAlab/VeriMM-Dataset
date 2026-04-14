module door_lock(
	input g,
	input h,
	output reg lock);always @(*) begin
    if ((g == 1 && h == 0) || (g == 0 && h == 1)) lock = 1;
    else lock = 0;
end

endmodule