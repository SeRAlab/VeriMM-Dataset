module top_module(input nReset,input clock,input [9:0] adc_databus,input testModeFlag,output [9:0] dataOut);reg [9:0] adcData; 
 reg [9:0] testData; 
 wire [9:0] adc_databusRead; 
 assign dataOut = testModeFlag ? testData : adcData; 
 always @ (posedge clock, negedge nReset) begin 
  if (!nReset) begin 
  adcData <= 10'd0; 
  testData <= 10'd0; 
  end else begin 
  adcData <= adc_databus; 
  testData <= testData + 10'd1; 
  end 
 end 
 endmodule