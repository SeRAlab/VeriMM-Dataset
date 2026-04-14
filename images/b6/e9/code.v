module top_module(
  input   CLK, RSTn,
  input RX_Done_Sig,
  input [7:0] RX_Data,
  output [7:0] data_tx,
  output RX_En_Sig
    );reg [7:0] rData;
    reg isEn;
    always @(posedge CLK or negedge RSTn)
    if( !RSTn )
         rData <= 8'd0;
    else if(RX_Done_Sig)
        begin rData<=RX_Data;isEn<=1'b0;end
    else isEn<=1'b1;
    assign data_tx = rData;
    assign RX_En_Sig = isEn;

endmodule