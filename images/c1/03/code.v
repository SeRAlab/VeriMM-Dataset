module adapter
(
	input 				ckmb,
	input 				ckdr,
	input 				reset,
	output				srd,
	output				swr,
	output	[33:5]		sa,
	output	[255:0]		swdat,
	output	[31:0]		smsk,
	input	[255:0]		srdat,
	input				srdy,
	output 				IO_Ready,
	input				IO_Addr_Strobe,
	input				IO_Read_Strobe,
	input				IO_Write_Strobe,
	output 	[31 : 0]	IO_Read_Data,
	input	[31 : 0] 	IO_Address,
	input	[3 : 0] 	IO_Byte_Enable,
	input	[31 : 0] 	IO_Write_Data,
	input	[3 : 0] 	page,
	input	[2:0]		dbg_out
);
reg 		[31 : 0]	rdat;
reg 		[255 : 0]	wdat;
reg 		[31 : 0]	msk;
reg 		[33 : 2]	addr;
reg						rdy1;
reg						rdy2;
reg						read;
reg						write;
wire		[31:0]		iowd;
wire		[3:0]		mask;
parameter				BADBAD = 256'hBAD0BAD0BAD0BAD0BAD0BAD0BAD0BAD0BAD0BAD0BAD0BAD0BAD0BAD0BAD0BAD0;
always @ (posedge ckmb) begin
	if (IO_Addr_Strobe && IO_Write_Strobe) begin
		case (IO_Address[4:2])
			0:	wdat[31:0] <= iowd;
			1:	wdat[63:32] <= iowd;
			2:	wdat[95:64] <= iowd;
			3:	wdat[127:96] <= iowd;
			4:	wdat[159:128] <= iowd;
			5:	wdat[191:160] <= iowd;
			6:	wdat[223:192] <= iowd;
			7:	wdat[255:224] <= iowd;
		endcase
		case (IO_Address[4:2])
			0:	msk <= {28'hFFFFFFF, mask};
			1:	msk <= {24'hFFFFFF, mask, 4'hF};
			2:	msk <= {20'hFFFFF, mask, 8'hFF};
			3:	msk <= {16'hFFFF, mask, 12'hFFF};
			4:	msk <= {12'hFFF, mask, 16'hFFFF};
			5:	msk <= {8'hFF, mask, 20'hFFFFF};
			6:	msk <= {4'hF, mask, 24'hFFFFFF};
			7:	msk <= {mask, 28'hFFFFFFF};
		endcase
	end
	if (IO_Addr_Strobe)
		addr <= {page[3:0], IO_Address[29:2]};	
end
always @ (posedge ckmb or posedge reset) begin
	if (reset) begin
		read		<= 1'b0;
		write		<= 1'b0;		
		rdy2		<= 1'b0;		
	end	else begin
		if (IO_Addr_Strobe && IO_Read_Strobe)
			read	<= 1'b1;
		else if (IO_Addr_Strobe && IO_Write_Strobe)
			write	<= 1'b1;
		if (rdy1) begin
			read	<= 1'b0;
			write	<= 1'b0;
			rdy2	<= 1'b1;
		end			
		if (rdy2)
			rdy2	<= 1'b0;
	end
end
always @ (posedge ckdr or posedge reset) begin
	if (reset) begin
		rdy1		<= 1'b0;
	end	else begin
		if (srdy)
			rdy1	<= 1'b1;
		if (rdy2)
			rdy1	<= 1'b0;		
		if (srdy) case (addr[4:2])
			0:	rdat <= srdat[31:0];
			1:	rdat <= srdat[63:32];
			2:	rdat <= srdat[95:64];
			3:	rdat <= srdat[127:96];
			4:	rdat <= srdat[159:128];
			5:	rdat <= srdat[191:160];
			6:	rdat <= srdat[223:192];
			7:	rdat <= srdat[255:224];
		endcase
	end
end
assign iowd 			= IO_Write_Data;
assign mask 			= ~IO_Byte_Enable;
assign IO_Read_Data		= rdat;
assign IO_Ready			= rdy2;
assign srd				= read;
assign swr				= write;
assign swdat			= wdat;
assign smsk				= msk;
assign sa				= addr[33:5];
endmodule