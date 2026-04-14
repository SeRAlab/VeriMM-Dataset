module logic_circuit(
	input u,
	input v,
	output reg w);always @(*) begin
    if (u == 1 && v == 0) w = 1;
    else w = 0;
end

endmodule