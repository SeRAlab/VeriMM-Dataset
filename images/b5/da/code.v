module top_module(
    input [10:0] in_val,
    output [10:0] out_val,
	 input load,
    input store,
    input clk,
	 output [2:0]level_out
    );reg [2:0]level = 0;
	assign level_out = level;
	reg [10:0]stack[2:0];
	
	always @(posedge clk) begin
		if (store) begin
			level <= level + 1;
			stack[level] <= in_val-1; 
			
		end
		if (load) begin
			level <= level - 1;
		end
	end
	
	assign out_val = stack[level-1];
	
endmodule