module top_module(
		input clk,
		input rst,
		input [31:0] St_value,
		input [31:0] Address,
		input Mem_W_EN,
		input Mem_R_EN,
		output [31:0] Mem_out
	);reg [31:0] Data_M [0:1023]; 
	integer i;
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			for (i = 0; i < 1024; i = i + 1)
                Data_M[i] <= 32'b0;
			
		end
		else begin
			if(Mem_W_EN)
				Data_M [Address] <= St_value;

		end

		
	end
	assign  Mem_out = Mem_R_EN? Data_M [Address]  : 32'b0  ;

endmodule