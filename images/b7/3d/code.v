module top_module(
   input         clock, reset, shiftLeft, shiftRight,
   input [7:0]   shiftData,
   output [7:0]  data);reg [7:0]      register;

   always @ (posedge clock) begin
      if (reset)
         register <= 8'b0;
      else if (shiftLeft)
         register <= {register[6:0], shiftData};
      else if (shiftRight)
         register <= {shiftData, register[7:1]};
   end

   assign data = register;
endmodule