module top_module(
    input logic clk, rst,
    input logic [1:0] p,
    output logic [1:0] q
);logic [1:0] single_reg;

	always_ff @(posedge clk, posedge rst) begin

		if (rst == 1) begin
			q <= 2'b00;
		end
		else begin
			q <= p;
		end
	
	end

endmodule