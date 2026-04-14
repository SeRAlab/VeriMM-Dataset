module top_module(
   input MRxClk, Reset, MRxDV, RxValid,
   input StateIdle, StateFFS, StatePreamble,
   input [1:0] StateData,
   input StateFrmCrc,
   input MRxDEqDataSoC,
   output TotalRecvNibCntEq0,
   output reg [15:0] TotalRecvNibCnt,  // Changed to reg
   output reg [7:0] RxRamAddr,          // Changed to reg
   output reg [3:0] FrmCrcNibCnt,       // Changed to reg
   output FrmCrcStateEnd
);wire ResetTotalRecvNibCnt, IncrementTotalRecvNibCnt;
   wire ResetRxRamAddr, IncrementRxRamAddr;
   wire IncrementFrmCrcNibCnt, ResetFrmCrcNibCnt;
   
   assign ResetTotalRecvNibCnt = StateIdle & ~MRxDV;
   assign IncrementTotalRecvNibCnt = MRxDV;
   always @(posedge MRxClk or posedge Reset) begin
      if (Reset) TotalRecvNibCnt <= 16'd0;
      else if (ResetTotalRecvNibCnt) TotalRecvNibCnt <= 16'd0;
      else if (IncrementTotalRecvNibCnt) TotalRecvNibCnt <= TotalRecvNibCnt + 16'd1;
   end
   
   assign TotalRecvNibCntEq0 = (TotalRecvNibCnt == 16'd0);
   
   assign ResetRxRamAddr = StateIdle | StateFFS | StatePreamble;
   assign IncrementRxRamAddr = RxValid;
   always @(posedge MRxClk or posedge Reset) begin
      if (Reset) RxRamAddr <= 8'd0;
      else if (ResetRxRamAddr) RxRamAddr <= 8'd0;
      else if (IncrementRxRamAddr) RxRamAddr <= RxRamAddr + 8'd1;
   end
   
   assign IncrementFrmCrcNibCnt = StateFrmCrc;
   assign ResetFrmCrcNibCnt = StateIdle;
   assign FrmCrcStateEnd = FrmCrcNibCnt[0];
   always @(posedge MRxClk or posedge Reset) begin
      if (Reset) FrmCrcNibCnt <= 4'd0;
      else if (ResetFrmCrcNibCnt) FrmCrcNibCnt <= 4'd0;
      else if (IncrementFrmCrcNibCnt) FrmCrcNibCnt <= FrmCrcNibCnt + 4'd1;
   end
endmodule