module top_module(
    input [1:0] ALUOut_W,
    input [31:0] ReadData_W,
    input [2:0] ExtDM_W,
    output reg [31:0] ReadData_W_R
    );wire [7:0] byte0 ;
	wire [15:0] half;
	
	assign byte0 = (ALUOut_W==2'b00) ? ReadData_W[7:0] : 
						(ALUOut_W==2'b01) ? ReadData_W[15:8] :
						(ALUOut_W==2'b10) ? ReadData_W[23:16] :
						(ALUOut_W==2'b11) ? ReadData_W[31:24] : 8'hx;
	assign half =  (ALUOut_W==2'b00) ? ReadData_W[15:0] :
						(ALUOut_W==2'b10) ? ReadData_W[31:16] : 16'hx;
	always @ (*)
	begin
		if(ExtDM_W==3'b000)
			ReadData_W_R=ReadData_W;
		else if(ExtDM_W==3'b001)
			ReadData_W_R={24'b0,byte0};
		else if(ExtDM_W==3'b010)
			ReadData_W_R={{24{byte0[7]}},byte0};
		else if(ExtDM_W==3'b011)
			ReadData_W_R={16'b0,half};
		else if(ExtDM_W==3'b100)
			ReadData_W_R={{16{half[15]}},half};
	end
endmodule