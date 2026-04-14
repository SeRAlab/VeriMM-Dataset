module top_module(input io_initial,input io_dataIn,output io_dataOut,input io_mainClk,input resetCtrl_systemReset);reg buffers_0; 
  reg buffers_1; 
  assign io_dataOut = buffers_1; 
  always @ (posedge io_mainClk or posedge resetCtrl_systemReset) begin 
  if (resetCtrl_systemReset) begin 
  buffers_0 <= io_initial; 
  buffers_1 <= io_initial; 
  end else begin 
  buffers_0 <= io_dataIn; 
  buffers_1 <= buffers_0; 
  end 
  end 
 endmodule