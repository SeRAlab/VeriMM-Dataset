module parallel_load_register (CLK, LOAD, D, Q);
input CLK, LOAD;
input [3:0] D;
output reg [3:0] Q;

always @(posedge CLK) begin
	if (LOAD) begin
		Q <= D;
	end
end

endmodule