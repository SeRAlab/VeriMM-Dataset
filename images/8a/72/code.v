module top_module(
						Addr,
						PClk,
						PosLock,
						PlsCnt,
						Axis,
						Din,
						
						DQ		
				
    );input[7:0]		Addr;
input				PClk;
input				PosLock;
input[15:0]		PlsCnt;
input[7:0]		Axis;
input[7:0]		Din;

output[7:0]			DQ;
wire[7:0]			DQ_0;
reg[15:0]		TxPlsCnt;

always @(posedge PosLock)
	begin
		TxPlsCnt <=PlsCnt;
	end


assign DQ_0 = (Addr[0] == 1'b1) ? TxPlsCnt[15:8] : TxPlsCnt[7:0];

assign DQ = (Addr[1] == 1'b1) ? Axis :  DQ_0;



endmodule