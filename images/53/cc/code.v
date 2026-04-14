module top_module(
addr1,
addr2,
writeAddr,
writeData,
writeEn,

dataOut1,
dataOut2
);input [4:0] addr1 ;
input [4:0] addr2 ;
input [4:0] writeAddr ;
input [31:0] writeData;
input writeEn;

output [31:0] dataOut1 ;
output [31:0] dataOut2 ;

wire [4:0] addr1 ;
wire [4:0] addr2 ;
wire [4:0] writeAddr ;
wire [31:0] writeData ;
wire writeEn;

reg [31:0] dataOut1 ;
reg [31:0] dataOut2 ;


reg [31:0] internalReg [0:31];

always @ (addr1 or addr2 or writeAddr or writeData)
begin 
  
  
  if (writeEn == 1'b1) begin
    internalReg[writeAddr] <= writeData;
  end
  else  begin
    internalReg[writeAddr] <= internalReg[writeAddr];
  end
  dataOut1 <= internalReg[addr1];
  dataOut2 <= internalReg[addr2];
end 

endmodule