module top_module(Clk,RS1,RS2,RD,WData,RegWr,RD1,RD2);input Clk,RegWr;
  input [4:0] RS1,RS2,RD;
  input [31:0] WData;
  output [31:0] RD1,RD2;
  
  reg [31:0] rf[31:0];

  always @(posedge Clk)
  begin
    rf[5'b0]<=32'b0;
  if(RegWr&&(RD!=5'b0)) 
    begin
  rf[RD]<= WData;
    end
  end
  
  assign RD1=(RS1!=0)?rf[RS1]:0;
  assign RD2=(RS2!=0)?rf[RS2]:0;
endmodule