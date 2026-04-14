module top_module(
  input clk, rst, micData, enable, dataIn,
  output reg [15:0] dataOut
);reg [15:0] buffer [0:255];
  reg [7:0] bufferIndex;
  reg processing;

  always @(posedge clk) begin
    if (rst) begin
      bufferIndex <= 0;
      processing <= 0;
      dataOut <= 0;
    end else begin
      if (enable) begin
        buffer[bufferIndex] <= micData;
        bufferIndex <= bufferIndex + 1;
      end
      if (dataIn) begin
        processing <= 1;
        bufferIndex <= 0;
      end
      if (processing) begin
        dataOut <= buffer[bufferIndex];
        bufferIndex <= bufferIndex + 1;
        if (bufferIndex == 255) begin
          processing <= 0;
        end
      end
    end
  end

endmodule