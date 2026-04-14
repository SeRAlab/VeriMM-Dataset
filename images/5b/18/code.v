module top_module(
	input[127:0] key,
	output reg[127:0] shift
);always@(key)
	begin
	shift[31:0] = {key[23:16],key[15:8],key[7:0],key[31:24]};
	shift[127:32] = key[127:32];
	end;
endmodule