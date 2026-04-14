module top_module(
	input clk,
	input rst,
	output[7:0] random_byte
);reg[7:0] register;

always @(posedge clk, posedge rst) begin
	if(rst) begin
		
		register <= 8'b10101101;
	end
	else begin
		
		register <= {register[0] ^ register[2] ^ register[3] ^ register[5], register[7:1]};
	end
end

assign random_byte = register;

endmodule