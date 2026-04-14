module top_module(
	input 		CLOCK,
	input 		RESET,
	input 		RW,
	input [4:0] DA,
	input [1:0] MD,
	input 		VxorN,
	input [31:0]F,
	input [31:0]Data,
	output[31:0]BUS_D,
	output		RW_out,
	output[4:0] DA_out
	);reg 		  RW_clocked;
reg [4:0]  DA_clocked;
reg [1:0]  MD_clocked;
reg [31:0] F_clocked;
reg [31:0] Data_clocked;
reg 		  VxorN_clocked;
reg [31:0] BUS_D_reg;

assign RW_out = RW_clocked;
assign DA_out = DA_clocked;
assign BUS_D = BUS_D_reg;

always @(negedge CLOCK)
	begin
		RW_clocked 	  <= RW;
		DA_clocked 	  <= DA;
		MD_clocked 	  <= MD;
		F_clocked 	  <= F;
		Data_clocked  <= Data;
		VxorN_clocked <= VxorN;
	end
	
always @(*)
	begin
		if(MD_clocked == 0)
			begin
				BUS_D_reg <= F_clocked;
			end
		if(MD_clocked == 1)
			begin
				BUS_D_reg <= Data_clocked;
			end
		if(MD_clocked == 2)
			begin
				BUS_D_reg <= {31'b0000000000000000000000000000000, VxorN};
			end
	end


endmodule