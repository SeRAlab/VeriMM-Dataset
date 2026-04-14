module TSHX2DQA(
	input T0, T1, SCLK, ECLK, DQSW270, RST,
	output Q
);
	parameter GSR = "ENABLED";
	parameter REGSET = "SET";

	reg [1:0] t_reg;
	reg [1:0] q_reg;

	always @(posedge SCLK) begin
		t_reg <= {T1, T0};
		if (DQSW270 && (GSR == "ENABLED")) begin
			q_reg <= 2'b0;
		end
	end

	always @(posedge ECLK) begin
		Q <= q_reg[1];
		q_reg <= {q_reg[0], t_reg[1]};
	end

	always @(posedge RST) begin
		if (REGSET == "SET") begin
			q_reg <= 2'b0;
		end
	end
endmodule