module top_module(
   input         clock, write, reset,
   input [15:0]  writeData,
   output [15:0] data);reg [15:0]    out = 16'b0;

   always @ (posedge clock) begin 
      if (reset)
         out = 16'b0;
      else if (write)
         out = writeData;
   end

   assign data = out;
endmodule