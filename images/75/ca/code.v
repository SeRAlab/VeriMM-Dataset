module top_module(
DACDataInput,
DACCS,
CLK,
SampleDelayZero,
DACLDAC,
DACPD,
DACWE,
IFFTOutput,
DMLocationWritingTo,
IFFTOutputWE,
IFFTOutputIndex
);input          CLK, SampleDelayZero, IFFTOutputWE;
input [9:0]    DMLocationWritingTo;
input [11:0]   IFFTOutput;
input [8:0]    IFFTOutputIndex;

output         DACCS, DACLDAC, DACPD, DACWE;
output [11:0]  DACDataInput;

reg [11:0]     DACDataInput;   
reg [14:0]     DACDelayCount;    

wire           SampleDelayZero, DACCS, IFFTOutputWE;
wire [11:0]    IFFTOutput;
wire [8:0]     IFFTOutputIndex;


   (* RAM_STYLE="{auto | block |  block_power1 | block_power2}" *)
reg [11:0]      StoredDACValues [0:1023];


assign DACCS     = 0;

assign DACLDAC   = 0;

assign DACPD     = 1;

assign DACWE     = (~| DACDelayCount[12:4]) && ( DACDelayCount[3]);



assign DACMemWE = IFFTOutputWE;   



always @(posedge CLK)
begin
  if (DACMemWE)
  begin
    StoredDACValues [ {!DMLocationWritingTo[9], IFFTOutputIndex} ] <= IFFTOutput[11:0];   
  end
  
  DACDataInput[11:0] <= StoredDACValues[DMLocationWritingTo + 4];
end


always @(posedge CLK)
begin
  if ( SampleDelayZero ) 
  begin
    DACDelayCount <= 0;
  end
  
  else
  begin
    DACDelayCount <= DACDelayCount + 1; 
  end
  
end  



endmodule