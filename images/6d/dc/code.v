module single_port_ram(
	input 		clk,
	input 		we,
	input  [3:0] addr,
	input  [7:0] data_in,
 
	output reg [7:0] data_out
);

reg [7:0] memory [15:0];

always @(posedge clk) begin
	if(we)
		memory[addr] <= data_in;
	data_out <= memory[addr];
end

endmodule