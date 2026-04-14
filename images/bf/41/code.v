module top_module(Data_out,Clk,Data_in,Address,RW);input [3:0]Data_in;
	input [2:0]Address;
	input Clk, RW;
	output reg [3:0]Data_out;	
	reg [3:0]AR;
	reg [3:0]BR;
	reg [3:0]CR;
	reg [3:0]DR;
	reg [3:0]ER;
	reg [3:0]FR;
	reg [3:0]GR;
	reg [3:0]HR;
	
	
	always @(negedge Clk)
	begin
		if(RW)
			begin
				case (Address)
					3'b000 : AR <= Data_in;
					3'b001 : BR <= Data_in;
					3'b010 : CR <= Data_in;
					3'b011 : DR <= Data_in;
					3'b100 : ER <= Data_in;
					3'b101 : FR <= Data_in;
					3'b110 : GR <= Data_in;
					3'b111 : HR <= Data_in;
				endcase
				Data_out <= 4'dz;
			end
		else
			begin
				case (Address)
					3'b000 : Data_out <= AR;
					3'b001 : Data_out <= BR;
					3'b010 : Data_out <= CR;
					3'b011 : Data_out <= DR;
					3'b100 : Data_out <= ER;
					3'b101 : Data_out <= FR;
					3'b110 : Data_out <= GR;
					3'b111 : Data_out <= HR;
				endcase
			end
	end
endmodule