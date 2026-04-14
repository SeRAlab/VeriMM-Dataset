module top_module(
input Clock,
input Reset,
output reg Out
);reg [14:0] LFSR;

always @(posedge Clock, negedge Reset) begin
	if(Reset==0) begin
		Out <= 0;
		LFSR <= 15'b111111111111111;
	end
	else begin
		LFSR[0] <= LFSR[13] ^ LFSR[14];
		LFSR[14:1] <= LFSR[13:0];
		if(LFSR==15'b001000010001100) Out <= 1;
	end
end

endmodule