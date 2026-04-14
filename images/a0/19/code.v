module top_module(clk, rst_n, hlt, pc_input, pc_output, stall);input hlt, rst_n, clk, stall;
	input [15:0] pc_input;
	output reg [15:0] pc_output;
	wire [15:0] nextInstr;	
	reg halt_encountered;

	always@(posedge clk, negedge rst_n) begin
		if(!rst_n)
			pc_output <= 0; 	
		else if(~stall && ~hlt)
			pc_output <= pc_input;	
		else
		  pc_output <= pc_output;  
	end

	
  
endmodule