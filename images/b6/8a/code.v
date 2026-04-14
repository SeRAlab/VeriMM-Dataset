module top_module(
   input clk,
   input [15:0] inData,
   output reg [15:0] out0,
   output reg [15:0] out1,
   input wr0a,
   input wr0b,
   input wr1a,
   input wr1b
);reg [15:0] buffer [0:3];
   integer head = 0, tail = 0;

   always @(posedge clk) begin
      if (wr0a) buffer[head] <= inData;
      if (wr0b) buffer[(head+1)%4] <= inData;
      if (wr1a) buffer[(head+2)%4] <= inData;
      if (wr1b) buffer[(head+3)%4] <= inData;

      out0 <= buffer[tail];
      out1 <= buffer[(tail+1)%4];

      head <= (head + wr0a + wr0b + wr1a + wr1b) % 4;
      tail <= (tail + 1) % 4;
   end

endmodule