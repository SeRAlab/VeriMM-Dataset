module top_module(clock, WE, WriteAddress1, WriteAddress2, ReadAddress1, ReadAddress2, WriteBus1, WriteBus2, ReadBus1, ReadBus2);input  clock, WE; 
input  [8:0] WriteAddress1, WriteAddress2, ReadAddress1, ReadAddress2; 
input  [191:0] WriteBus1, WriteBus2;
output [191:0] ReadBus1;
output [191:0] ReadBus2;

reg [191:0]   Register [0:511];   
reg [191:0]   ReadBus1, ReadBus2;


reg [511:0] WElines1, WElines2;
integer i;



always@(*)	begin
#1.5 WElines1 = (WE << WriteAddress1);
	 WElines2 = (WE << WriteAddress2);
end

always@(posedge clock)	begin
    for (i=0; i<512; i=i+1)	begin
      if (WElines1[i]) Register[i] <= WriteBus1;
	  if (WElines2[i]) Register[i] <= WriteBus2;
	end
end  


always@(*) 
  begin 
    #1.5   ReadBus1  =  Register[ReadAddress1];
    	 ReadBus2  =  Register[ReadAddress2];
  end
endmodule