module top_module(
   // Outputs
   outData,
   // Inputs
   clk, inData, wrEn, rdEn
   );parameter fifoDepthLog2 = 2; // depth of 4 elements
   parameter fifoDepth   = 1<<fifoDepthLog2;

   input clk;
   input [15:0] inData;
   input wrEn, rdEn;

   output reg [15:0] outData; // Changed to reg to allow assignment in always block

   reg [15:0] fifo[0:fifoDepth-1];
   reg [1:0] wrPtr = 2'b0; // write pointer initialized to 0
   reg [1:0] rdPtr = 2'b0; // read pointer initialized to 0
   reg [1:0] nextWrPtr;
   reg [1:0] nextRdPtr;

   always @(posedge clk) begin
      // Write operation
      if (wrEn) begin
         fifo[wrPtr] <= inData;
         nextWrPtr = wrPtr + 1;
         if (nextWrPtr == fifoDepth) begin
            nextWrPtr = 0;
         end
      end
      
      // Read operation
      if (rdEn) begin
         outData <= fifo[rdPtr]; // can now be assigned since outData is reg
         nextRdPtr = rdPtr + 1;
         if (nextRdPtr == fifoDepth) begin
            nextRdPtr = 0;
         end
      end
      
      wrPtr <= nextWrPtr;
      rdPtr <= nextRdPtr;
   end

endmodule