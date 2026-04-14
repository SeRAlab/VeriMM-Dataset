module johnson_counter (CLK, RST, Q);
input CLK, RST;
output reg [3:0] Q;

always @(posedge CLK) begin
	if (RST) begin
		Q <= 4'b0000;
	end
	else begin
		Q <= {Q[2:0], ~Q[3]};
	end
end

endmodule