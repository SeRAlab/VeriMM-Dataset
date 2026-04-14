module top_module(
    input wire [25:0] Data_Dec_i,
    output reg [4:0] Data_Bin_o
    );always @(Data_Dec_i)
	begin
		if(~Data_Dec_i[25]) begin Data_Bin_o = 5'b00000;
		end else if(~Data_Dec_i[24]) begin Data_Bin_o = 5'b00001;
		end else if(~Data_Dec_i[23]) begin Data_Bin_o = 5'b00010;
		end else if(~Data_Dec_i[22]) begin Data_Bin_o = 5'b00011;
		end else if(~Data_Dec_i[21]) begin Data_Bin_o = 5'b00100;
		end else if(~Data_Dec_i[20]) begin Data_Bin_o = 5'b00101;
		end else if(~Data_Dec_i[19]) begin Data_Bin_o = 5'b00110;
		end else if(~Data_Dec_i[18]) begin Data_Bin_o = 5'b00111;
		end else if(~Data_Dec_i[17]) begin Data_Bin_o = 5'b01000;
		end else if(~Data_Dec_i[16]) begin Data_Bin_o = 5'b01001;
		end else if(~Data_Dec_i[15]) begin Data_Bin_o = 5'b01010;
		end else if(~Data_Dec_i[14]) begin Data_Bin_o = 5'b01011;
		end else if(~Data_Dec_i[13]) begin Data_Bin_o = 5'b01100;
		end else if(~Data_Dec_i[12]) begin Data_Bin_o = 5'b01101;
		end else if(~Data_Dec_i[11]) begin Data_Bin_o = 5'b01110;
		end else if(~Data_Dec_i[10]) begin Data_Bin_o = 5'b01111;
		end else if(~Data_Dec_i[9])  begin Data_Bin_o = 5'b10000;
		end else if(~Data_Dec_i[8])  begin Data_Bin_o = 5'b10001;
		end else if(~Data_Dec_i[7])  begin Data_Bin_o = 5'b10010;
		end else if(~Data_Dec_i[6])  begin Data_Bin_o = 5'b10011;
		end else if(~Data_Dec_i[5])  begin Data_Bin_o = 5'b10100;
		end else if(~Data_Dec_i[4])  begin Data_Bin_o = 5'b10101;
		end else if(~Data_Dec_i[3])  begin Data_Bin_o = 5'b10110;
		end else if(~Data_Dec_i[2])  begin Data_Bin_o = 5'b10111;
		end else if(~Data_Dec_i[1])  begin Data_Bin_o = 5'b11000;
		end else if(~Data_Dec_i[0])  begin Data_Bin_o = 5'b10101;
		end
		else Data_Bin_o = 5'b00000;
	
	end
endmodule