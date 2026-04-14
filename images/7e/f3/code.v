module top_module(
	input 		clk20,		 	
    input [7:0] TxData,         
	input 		SendingPacket,
	output		NextByte,
	output reg	Ethernet_Tx 	
);assign 		NextByte = (ShiftCount==15);
reg [7:0] 	ShiftData; 
reg [3:0] 	ShiftCount;
always @(posedge clk20) ShiftCount <= SendingPacket ? ShiftCount + 4'd1 : 4'd15;
always @(posedge clk20) if(ShiftCount[0]) ShiftData <= NextByte ? TxData : {1'b0, ShiftData[7:1]};


reg [17:0] 	LinkPulseCount; 
reg 		LinkPulse; 
always @(posedge clk20) LinkPulseCount <= SendingPacket ? 18'd0 : LinkPulseCount + 18'd1;
always @(posedge clk20) LinkPulse <= &LinkPulseCount[17:1];


reg 		qo;
reg 		qoe; 
reg 		SendingPacketData; 
reg [2:0] 	idlecount; 
always @(posedge clk20) SendingPacketData <= SendingPacket;
always @(posedge clk20) if(SendingPacketData) idlecount <= 3'd0; else if(~&idlecount) idlecount <= idlecount + 3'd1;
always @(posedge clk20) qo  <= SendingPacketData ? ~ShiftData[0]^ShiftCount[0] : 1'b1;
always @(posedge clk20) qoe <= SendingPacketData | LinkPulse | (idlecount<6);
always @(posedge clk20) Ethernet_Tx <= (qoe ?  qo : 1'b0);


endmodule