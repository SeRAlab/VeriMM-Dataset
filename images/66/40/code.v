module top_module(	input 			clk,	 
						rst,	 
			input[2:0] 		rs1,	 
						rs2,	 
						rd,	 
			input[15:0]		data_in, 
			input			write_reg,	 

			output reg[15:0]	reg1data,
						reg2data
		);reg [15:0] registers[7:0]; 
		reg [2:0] rd_last; 
		
		integer index = 0;
		

		always @ (posedge clk or posedge rst)
		begin
			if (rst == 1)
			begin
				rd_last <= 0;
				for( index=0; index<=7; index = index + 1)
				begin
					registers[index] <= 16'b0000_0000_0000_0000;
			end	
			end
			else
			begin
				if (write_reg == 1)
				begin
					registers[rd_last] <= data_in;
				end
				rd_last <= rd;

				reg1data <= registers[rs1]; 
				reg2data <= registers[rs2]; 
			end
		end



endmodule