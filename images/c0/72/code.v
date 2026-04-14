module ag6502_phase_shift(input baseclk, input phi_0, output reg phi_1);
	parameter DELAY = 1; 
	initial phi_1 = 0;
	integer cnt = 0;
	always @(posedge baseclk) begin
		if (phi_0 != phi_1) begin
			if (!cnt) begin phi_1 <= phi_0; cnt <= DELAY; end
			else cnt <= cnt - 1;
		end
	end
endmodule