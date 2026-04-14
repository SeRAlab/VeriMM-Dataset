module top_module(
	input clock, reset,
	input [7:0] multiplicand, multiplier,
	input Load_regs, Decr_P, Add_regs, Shift_regs,
	output [15:0] product,
	output reg Nothing,
	output Zero, Q0
);parameter m_size = 8;

reg [7:0] A, B, Q;
reg C;
reg [3:0] P;
wire [7:0] M;

always @(posedge clock, posedge reset)
begin
	if (reset) begin
		A <= 0;
		C <= 0;
		B <= 0;
		Q <= 0;
		P <= m_size;
	end else begin
		if (Load_regs) begin
			A = 0;
			C = 0;
			B = multiplicand;
			Q = multiplier;
			P = m_size;
		end else begin
			if (Add_regs) {C, A} = A + B;
			if (Shift_regs) {C, A, Q} = {C, A, Q} >> 1;
			if (Decr_P) P = P-1;
		end
	end
end


always @(*)
begin
	if (Load_regs) begin
		Nothing = ~|{multiplicand, multiplier};
	end else begin
		Nothing = M == 0 || B == 0;
	end
end
assign product = {A, Q} >> P;
assign M = Q << (m_size - P - 1);
assign Zero = P == 4'b0;
assign Q0 = Q[0];

endmodule