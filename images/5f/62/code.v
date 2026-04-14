module top_module(input [7:0] register0, output branch);reg branch_reg;

always @(*)
begin
	if (register0 == 8'b0000) begin
		branch_reg <= 1'b1;
	end else begin
		branch_reg <= 1'b0;
	end

end

assign branch = branch_reg;

endmodule