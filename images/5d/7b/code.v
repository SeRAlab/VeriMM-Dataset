module top_module(
    input [2:0] RD,
    input [7:0] Write_Data,
    output [7:0] Read_Data,
    input Reg_Write,
    input Clk,
    input Reset
    );reg[7:0] RegFile[7:0]; 
	 assign Read_Data = RegFile[RD];	 
	 
	 always@(Reset)
	 begin
		if(Reset == 0)
		begin
			RegFile[0]=8'b00000000; RegFile[1]=8'b00000001; 
			RegFile[2]=8'b00000010; RegFile[3]=8'b00000011;
			RegFile[4]=8'b00000100; RegFile[5]=8'b00000101; 
			RegFile[6]=8'b00000110; RegFile[7]=8'b00000111;
		end
	end
	
	
	always@(posedge Clk)
		begin
			if(Reg_Write == 1)
			begin
				RegFile[RD] <= Write_Data;
			end
		end
endmodule