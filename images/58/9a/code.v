module top_module(iDATA,oDATA,iADDR,iRD_N,iWR_N,iCS_N,iRST_N,iCLK,oINT,HPI_DATA,HPI_ADDR,HPI_RD_N,HPI_WR_N,HPI_CS_N,HPI_RST_N,HPI_INT);input [31:0] iDATA; 
 input [1:0] iADDR; 
 input iRD_N; 
 input iWR_N; 
 input iCS_N; 
 input iRST_N; 
 input iCLK; 
 output [31:0] oDATA; 
 output oINT; 
 inout [15:0] HPI_DATA; 
 output [1:0] HPI_ADDR; 
 output HPI_RD_N; 
 output HPI_WR_N; 
 output HPI_CS_N; 
 output HPI_RST_N; 
 input HPI_INT; 
 reg [1:0] HPI_ADDR; 
 reg HPI_RD_N; 
 reg HPI_WR_N; 
 reg HPI_CS_N; 
 reg [15:0] TMP_DATA; 
 reg [31:0] oDATA; 
 reg oINT; 
 assign HPI_DATA = HPI_WR_N ? 16'hzzzz : TMP_DATA ; 
 always@(posedge iCLK or negedge iRST_N) 
 begin 
  if(!iRST_N) 
  begin 
  TMP_DATA <= 0; 
  HPI_ADDR <= 0; 
  HPI_RD_N <= 1; 
  HPI_WR_N <= 1; 
  HPI_CS_N <= 1; 
  TMP_DATA <= 0; 
  oDATA <= 0; 
  oINT <= 0; 
  end 
  else 
  begin 
  oDATA <= {16'h0000,HPI_DATA}; 
  oINT <= HPI_INT; 
  TMP_DATA <= iDATA[15:0]; 
  HPI_ADDR <= iADDR[1:0]; 
  HPI_RD_N <= iRD_N; 
  HPI_WR_N <= iWR_N; 
  HPI_CS_N <= iCS_N; 
  end 
 end 
 assign HPI_RST_N = iRST_N; 
 endmodule