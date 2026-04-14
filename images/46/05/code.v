module top_module(input logic [3:0] a,
	output logic [3:0] y);always @(*)
	begin
		casez(a)
			4'b1???: y = 4'b1000;
			4'b?1??: y = 4'b0100;
			4'b??1?: y = 4'b0010;
			4'b???1: y = 4'b0001;
			default: y = 4'b0000;
		endcase
	end

endmodule