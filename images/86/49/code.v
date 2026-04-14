module top_module(_Enable, Data, Address, RWSelect, RClock, WClock);parameter SIZE = 2048; 
parameter DATABITS = 8;
parameter ADDRESSBITS = 7;
inout [DATABITS-1:0] Data;
input [ADDRESSBITS-1:0] Address;
input RWSelect; 
input RClock,WClock,_Enable;
reg [DATABITS-1:0] Data_Regs [SIZE-1:0]; 
reg [DATABITS-1:0] DataBuff;


always @(negedge WClock) begin
  if (~_Enable) Data_Regs [Address] <= Data; 
end


always @(negedge RClock) begin
  if (~_Enable) DataBuff <= Data_Regs [Address]; 
end
assign Data = (RWSelect) ? DataBuff:'bz;endmodule