module top_module(
	input mode_i,
	input [1023:0] key_register_i,
	input [1023:0] key_constant_i,
	
	output [1023:0] key_o
    );reg [1023:0] key;

assign key_o = key;

always @(*) begin
	if (mode_i) 
	begin
		key[1023:0] = key_register_i[1023:0];
	end else begin 
		key[1023:0] = key_constant_i[1023:0];
	end
end

endmodule