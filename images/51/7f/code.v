module top_module(
	input 	clk,		    		
	output	dma,					
	input	dmal,					
	input	dmas,					
	input	speed,
	input	turbo,
	input	[8:0] hpos,				
	output	wr,						
	input 	[8:1] reg_address_in,	
	output 	[8:1] reg_address_out,	
	input	[15:0] data_in,			
	output	reg [20:1] address_out	
);parameter DSKPTH  = 9'h020;
parameter DSKPTL  = 9'h022;
parameter DSKDAT  = 9'h026;
parameter DSKDATR = 9'h008;


wire	[20:1] address_outnew;	
reg		dmaslot;				







always @(hpos or speed)
	case (hpos[8:1])
		8'h04:	 dmaslot = speed;
		8'h06:	 dmaslot = speed;
		8'h08:	 dmaslot = speed;
		8'h0A:	 dmaslot = speed;
		8'h0C:	 dmaslot = 1;
		8'h0E:	 dmaslot = 1;
		8'h10:	 dmaslot = 1;
		default: dmaslot = 0;
	endcase


assign dma = dmal & (dmaslot & ~(turbo & speed) & hpos[0] | turbo & speed & ~hpos[0]);

assign wr = ~dmas;




assign address_outnew[20:1] = dma ? address_out[20:1]+1'b1 : {data_in[4:0],data_in[15:1]};


always @(posedge clk)
	if (dma || (reg_address_in[8:1] == DSKPTH[8:1]))
		address_out[20:16] <= address_outnew[20:16];
always @(posedge clk)
	if (dma || (reg_address_in[8:1] == DSKPTL[8:1]))
		address_out[15:1] <= address_outnew[15:1];




assign reg_address_out[8:1] = wr ? DSKDATR[8:1] : DSKDAT[8:1];



endmodule