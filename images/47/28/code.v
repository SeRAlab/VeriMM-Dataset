module top_module(
  input RX, 
  input CLK,
  output [7:0] data,
  output valid);reg RX_1;
reg RX_2;
always @(posedge CLK) begin
  RX_1 <= RX;
  RX_2 <= RX_1;
end

wire RXi;
assign RXi = RX_2;

reg [8:0] dataReg;
reg validReg = 0;
assign data = dataReg[7:0];
assign valid = validReg;

reg [12:0] readClock = 0; 
reg [3:0] readBit = 0; 
reg reading = 0;


always @ (posedge CLK)
begin
  if(RXi==0 && reading==0) begin
    reading <= 1;
    readClock <= 150; 
    readBit <= 0;
    validReg <= 0;
  end else if(reading==1 && readClock==0 && readBit==8) begin
    
    reading <= 0;
    dataReg[8] <= RXi;
    validReg <= 1;
  end else if(reading==1 && readClock==0) begin
    
    dataReg[readBit] <= RXi;
    readClock <= 100;
    readBit <= readBit + 1;
    validReg <= 0;
  end else if(reading==1 && readClock>0) begin
    readClock <= readClock - 1;
    validReg <= 0;
  end else begin
    validReg <= 0;
  end
end
endmodule