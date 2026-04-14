module top_module(
                 oRxD_DATA, oRxD_Ready,

                 
                 TDI, TCS, TCK);input             TDI, TCS, TCK;
output reg  [7:0] oRxD_DATA;
output reg        oRxD_Ready;

reg         [7:0] rDATA;
reg         [2:0] rCont;

always@(posedge TCK or posedge TCS)
begin
  if(TCS)
  begin
    oRxD_Ready <= 1'b0;
    rCont      <= 3'b000;
  end
  else
  begin
    rCont        <= rCont + 3'b001;
    rDATA        <= {TDI, rDATA[7:1]};

    if (rCont == 3'b000)
    begin
      oRxD_DATA  <= {TDI, rDATA[7:1]};
      oRxD_Ready <= 1'b1;
    end
    else
    begin
      oRxD_Ready <= 1'b0;
    end
  end
end             
endmodule