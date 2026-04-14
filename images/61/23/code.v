module top_module( // HOST Side
                   input [15:0] iDATA,
                   output reg [15:0] oDATA,
                   input iCMD,
                   input iRD_N,
                   input iWR_N,
                   input iCS_N,
                   input iRST_N,
                   input iCLK,
                   input iOSC_50,
                   output reg oINT,
                   // DM9000A Side
                   inout [15:0] ENET_DATA,
                   output reg ENET_CMD,
                   output reg ENET_RD_N,
                   output reg ENET_WR_N,
                   output reg ENET_CS_N,
                   output ENET_RST_N,
                   output reg ENET_CLK,
                   input ENET_INT
                  );reg [15:0] TMP_DATA;

   assign ENET_DATA = ENET_WR_N ? 16'hzzzz : TMP_DATA;
   
   always @(posedge iCLK or negedge iRST_N) begin
      if (!iRST_N) begin
         TMP_DATA <= 16'h0;
         ENET_CMD <= 1'b0;
         ENET_RD_N <= 1'b1;
         ENET_WR_N <= 1'b1;
         ENET_CS_N <= 1'b1;
         oDATA <= 16'h0;
         oINT <= 1'b0;
      end
      else begin
         oDATA <= ENET_DATA;
         oINT <= ENET_INT;
         TMP_DATA <= iDATA;
         ENET_CMD <= iCMD;
         ENET_CS_N <= iCS_N;
         ENET_RD_N <= iRD_N;
         ENET_WR_N <= iWR_N;
      end
   end
   
   always @(posedge iOSC_50) begin
      ENET_CLK <= ~ENET_CLK;
   end
   
   assign ENET_RST_N = iRST_N;
   
endmodule