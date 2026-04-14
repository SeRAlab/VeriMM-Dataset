module top_module(
	input [31:0] PC_M1,
	input [31:0] A_DATA,
	input [31:0] B_DATA,
	input [31:0] SEorZF,
	input        MA,
	input			 MB,
	output[31:0] BUS_A,
	output[31:0] BUS_B
    );reg [31:0]BUS_A_reg;
reg [31:0]BUS_B_reg;

assign BUS_A = BUS_A_reg;
assign BUS_B = BUS_B_reg;


always @(*)
	begin
		if(MA == 1)
			begin
				BUS_A_reg <= PC_M1;
			end
		if(MA == 0)
			begin
				BUS_A_reg <= A_DATA;
			end
			
		if(MB == 1)
			begin
				BUS_B_reg <= SEorZF;
			end
		if(MB == 0)
			begin
				BUS_B_reg <= B_DATA;
			end
	end

endmodule