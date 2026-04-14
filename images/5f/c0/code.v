module top_module(clock, WE, WriteAddress, ReadAddress1, ReadAddress2, WriteBus, ReadBus1, ReadBus2);input  clock, WE; 
input  [10:0] WriteAddress, ReadAddress1, ReadAddress2; 
input  [255:0] WriteBus;
output [255:0] ReadBus1;
output [255:0] ReadBus2;

reg [255:0] Register [0:1799];   
reg [255:0] ReadBus1;
reg [255:0] ReadBus2;


reg [1799:0] WElines;
integer i;



always@(*)
#3 WElines = (WE << WriteAddress);


always@(posedge clock)
    for (i=0; i<1800; i=i+1)
      if (WElines[i]) Register[i] <= WriteBus;


always@(*) 
  begin 
    #3   ReadBus1  =  Register[ReadAddress1];
	 ReadBus2  =  Register[ReadAddress2];
  end
endmodule