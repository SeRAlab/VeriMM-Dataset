module top_module(CLK,RST,RDEN_DATA,RDEN_MSG,DATA,MSG,ERR0,ERR1,ERR2,ERR3,ERR_MSG);input CLK,RST,RDEN_DATA,RDEN_MSG;
input [31:0] DATA;
input [39:0] MSG;

output reg [3:0] ERR0,ERR1,ERR2,ERR3,ERR_MSG;

reg [31:0] DATA_TEMP;
reg [7:0] MSG_TEMP;

always @ (posedge CLK)
begin
	if(RST)
	begin
		ERR0 <= 0; 
		ERR1 <= 0; 
		ERR2 <= 0; 
		ERR3 <= 0; 
		ERR_MSG <= 0; 
		DATA_TEMP <= 0;
		MSG_TEMP <= 0;
	end
	else if(RDEN_DATA)
	begin
		DATA_TEMP <= DATA;
		MSG_TEMP <= MSG;
		if(DATA_TEMP[7:0] + 1 != DATA[7:0] && DATA[7:0] != 0)
			ERR0 <= ERR0 + 1;
		if(DATA_TEMP[15:8] + 1 != DATA[15:8] && DATA[15:8] != 0)
			ERR1 <= ERR1 + 1;
		if(DATA_TEMP[23:16] + 1 != DATA[23:16] && DATA[23:16] != 0)
			ERR2 <= ERR2 + 1;
		if(DATA_TEMP[31:24] + 1 != DATA[31:24] && DATA[31:24] != 0)
			ERR3 <= ERR3 + 1;
		if(MSG[39:32] + 1 != MSG[31:24] || MSG[31:24] + 1 != MSG[23:16] || MSG[23:16] + 1 != MSG[15:8] || MSG[15:8] + 1 != MSG[7:0])
			ERR_MSG <= ERR_MSG + 1;
	end
end
endmodule