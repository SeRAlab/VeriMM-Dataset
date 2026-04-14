module top_module(inData,outData);input [31:0]inData;
  output [31:0]outData;
  reg [31:0]outData=0;
  
  always@(inData)
    begin
      
      outData=inData<<2;
  
    end
    
endmodule