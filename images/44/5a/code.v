module top_module(
	input clk         , 
	input [4:0] address     , 
	input [31:0] data        , 
	input we          , 
	
	
	output wire [31:0] data_out,     
	
	
	input write_ins,
	input [4:0] ins_address,
	input [31:0] ins
);reg [31:0] mem [0:31];


assign data_out = mem[address];



always @ (negedge clk) begin
	if (we)
		mem[address] <= data;
end


always @(posedge write_ins) begin
	mem[ins_address] <= ins;
end


endmodule