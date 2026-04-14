module BufferCC (
      input   io_dataIn,
      output  io_dataOut,
      input   io_mainClk);

  reg  buffers_0;
  reg  buffers_1;
  
  assign io_dataOut = buffers_1;
  
  always @ (posedge io_mainClk) begin
    buffers_0 <= io_dataIn;
    buffers_1 <= buffers_0;
  end

endmodule